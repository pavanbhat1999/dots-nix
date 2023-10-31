// importing
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync,timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Brightness from './brightness.js';
import icons from './icons.js';
import {
    NotificationList, DNDSwitch, ClearButton, PopupList,
} from './widgets.js';
// import applauncher from './applauncher.js';

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, just make it a function
// then you can use it by calling simply calling it

// const Workspaces = () => Widget.Box({
//     className: 'workspaces',
//     connections: [[Hyprland.active.workspace, self => {
//         // generate an array [1..10] then make buttons from the index
//         const arr = Array.from({ length: 10 }, (_, i) => i + 1);
//         self.children = arr.map(i => Widget.Button({
//             onClicked: () => execAsync(`hyprctl dispatch workspace ${i}`),
//             child: Widget.Label(`${i}`),
//             className: Hyprland.active.workspace.id == i ? 'focused' : '',
//         }));
//     }]],
// });

const Header = () => Widget.Box({
    className: 'header',
    children: [
        Widget.Label('Do Not Disturb'),
        DNDSwitch(),
        Widget.Box({ hexpand: true }),
        ClearButton(),
    ],
});

const NotificationCenter = () => Widget.Window({
    name: 'notification-center',
    anchor: ['right', 'top', 'bottom'],
    popup: true,
    focusable: true,
    child: Widget.Box({
        children: [
            Widget.EventBox({
                hexpand: true,
                connections: [['button-press-event', () =>
                    App.closeWindow('notification-center')]]
            }),
            Widget.Box({
                vertical: true,
                children: [
                    Header(),
                    NotificationList(),
                ],
            }),
        ],
    }),
});

const NotificationsPopupWindow = () => Widget.Window({
    name: 'popup-window',
    anchor: ['top'],
    child: PopupList(),
});

timeout(500, () => execAsync([
    'notify-send',
    'Notification Center example',
    'To have the panel popup run "ags toggle-window notification-center"' +
    '\nPress ESC to close it.',
]).catch(console.error));

const WifiIndicator = () => Widget.Box({
    children: [
        Widget.Icon({
            binds: [['icon', Network.wifi, 'icon-name']],
        }),
        Widget.Label({
            binds: [['label', Network.wifi, 'ssid']],
        }),
    ],
});

const WiredIndicator = () => Widget.Icon({
    binds: [['icon', Network.wired, 'icon-name']],
});

const NetworkIndicator = () => Widget.Stack({
    items: [
        ['wifi', WifiIndicator()],
        ['wired', WiredIndicator()],
    ],
    binds: [['shown', Network, 'primary', p => p || 'wifi']],
});

const focusedTitle = Widget.Label({
    binds: [
        ['label', Hyprland.active.client, 'title'],
        ['visible', Hyprland.active.client, 'address', addr => !!addr],
    ],
});

const dispatch = ws => Utils.execAsync(`hyprctl dispatch workspace ${ws}`);
let testVar=['0',
    "",
    "",
    "",
    "󰨞",
    "",
    "󰙯",
    "",
    "",
    "",
];
const Workspaces = () => Widget.EventBox({
    onScrollUp: () => dispatch('+1'),
    onScrollDown: () => dispatch('-1'),
    child: Widget.Box({
        className: 'workspaces',
        children: Array.from({ length: 10 }, (_, i) => i + 1).map(i => Widget.Button({
            setup: btn => btn.id = i,
            label: ` ${i}: ${testVar[`${i}`]}`,
            onClicked: () => dispatch(i),
            // className: Hyprland.active.workspace.id == i ? 'focused' : '',
        })),
        // remove this connection if you want fixed number of buttons
        connections: [[Hyprland, box => box.children.forEach(btn => {
            btn.visible = Hyprland.workspaces.some(ws => ws.id === btn.id);
            btn.toggleClassName('current-workspace', Hyprland.active.workspace.id === btn.id);
        })]],
    }),
});
const ClientTitle = () => Widget.Label({
    className: 'client-title',
    binds: [
        ['label', Hyprland.active.client, 'title', t => `${t.slice(0,30)}`],
    ],
});

const Clock = () => Widget.Label({
    className: 'clock',
    connections: [
        // this is bad practice, since exec() will block the main event loop
        // in the case of a simple date its not really a problem
        // [1000, self => self.label = exec('date "+%H:%M:%S %b %e."')],

        // this is what you should do
        [1000, self => execAsync(['date', '+%I:%M %p %b %e.'])
            .then(date => self.label = date).catch(console.error)],
    ],
});

// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
const Notification = () => Widget.Box({
    className: 'notification',
    children: [
        Widget.Icon({
            icon: 'preferences-system-notifications-symbolic',
            connections: [
                [Notifications, self => self.visible = Notifications.popups.length > 0],
            ],
        }),
        Widget.Label({
            connections: [[Notifications, self => {
                self.label = Notifications.popups[0]?.summary || '';
            }]],
        }),
    ],
});

const Media = () => Widget.Button({
    className: 'media',
    onPrimaryClick: () => Mpris.getPlayer('')?.playPause(),
    onScrollUp: () => Mpris.getPlayer('')?.next(),
    onScrollDown: () => Mpris.getPlayer('')?.previous(),
    child: Widget.Label({
        connections: [[Mpris, self => {
            const mpris = Mpris.getPlayer('');
            // mpris player can be undefined
            if (mpris)
                self.label = `${mpris.trackArtists.join(', ')} - ${mpris.trackTitle}`;
            else
                self.label = 'Nothing is playing';
        }]],
    }),
});

const Volume = (type = 'speaker') => Widget.Box({
    className: 'volume',
    style: 'min-width: 100px',
    children: [
        Widget.Stack({
            items: [
                // tuples of [string, Widget]
                ['101', Widget.Icon('audio-volume-overamplified-symbolic')],
                ['67', Widget.Icon('audio-volume-high-symbolic')],
                ['34', Widget.Icon('audio-volume-medium-symbolic')],
                ['1', Widget.Icon('audio-volume-low-symbolic')],
                ['0', Widget.Icon('audio-volume-muted-symbolic')],
            ],
            connections: [[Audio, self => {
                if (!Audio.speaker)
                    return;
                self.tooltipText = `Volume ${Math.floor(Audio[type].volume * 100)}%`;
                if (Audio.speaker.isMuted) {
                    self.shown = '0';
                    return;
                }

                const show = [101, 67, 34, 1, 0].find(
                    threshold => threshold <= Audio.speaker.volume * 100);

                self.shown = `${show}`;
            }, 'speaker-changed']],
        }),
        Widget.Slider({
            hexpand: true,
            drawValue: false,
            onChange: ({ value }) => Audio.speaker.volume = value,
            connections: [[Audio, self => {
                self.value = Audio.speaker?.volume || 0;
            }, 'speaker-changed']],
        }),
    ],
});

const BrightnessSlider = () => Widget.Slider({
    drawValue: false,
    hexpand: true,
    binds: [['value', Brightness, 'screen']],
    onChange: ({ value }) => Brightness.screen = value,
});
const BrightnessWidget = () => Widget.Box({
    className: 'slider',
    style: 'min-width: 100px',
    children: [
        Widget.Icon({
            icon: icons.brightness.indicator,
            className: 'icon',
            binds: [['tooltip-text', Brightness, 'screen', v =>
                `Screen Brightness: ${Math.floor(v * 100)}%`]],
        }),
        BrightnessSlider(),
    ],
});

const BatteryLabel = () => Widget.Box({
    className: 'battery',
    children: [

        Widget.Icon({
            connections: [[Battery, self => {
                self.icon = `battery-level-${Math.floor(Battery.percent / 10) * 10}-symbolic`;
                self.tooltipText = `Charging:${Battery.charging}`
            }]],
        }),
        Widget.Label({
    binds: [['label', Battery, 'percent', p => `${p}%`]],
        }),
        // Widget.ProgressBar({
        //     valign: 'center',
        //     connections: [[Battery, self => {
        //         if (Battery.percent < 0)
        //             return;
        //
        //         self.fraction = Battery.percent / 100;
        //     }]],
        // }),
    ],
});

const SysTray = () => Widget.Box({
    className: "sys-tray",
    connections: [[SystemTray, self => {
        self.children = SystemTray.items.map(item => Widget.Button({
            child: Widget.Icon({ binds: [['icon', item, 'icon']] }),
            onPrimaryClick: (_, event) => item.activate(event),
            onSecondaryClick: (_, event) => item.openMenu(event),
            binds: [['tooltip-markup', item, 'tooltip-markup']],
        }));
    }]],
});
//
const notificationbtn = Widget.Button({
    child: Widget.Label(' '),
    onPrimaryClick: 'ags -t notification-center',
});
//
//NOTE: RAM and CPU
const divide = ([total, free]) => free / total;

const cpu = Variable(0, {
    poll: [2000, 'top -b -n 1', out => divide([100, out.split('\n')
        .find(line => line.includes('Cpu(s)'))
        .split(/\s+/)[1]
        .replace(',', '.')])],
});

const ram = Variable(0, {
    poll: [2000, 'free', out => divide(out.split('\n')
        .find(line => line.includes('Mem:'))
        .split(/\s+/)
        .splice(1, 2))],
});

const cpuProgress = Widget.CircularProgress({
   style:
        'min-width: 30px;' + // its size is min(min-height, min-width)
        'min-height: 30px;' +
        'font-size: 7px;' + // to set its thickness set font-size on it
        'margin: 0px;' + // you can set margin on it
        'background-color: #131313;' + // set its bg color
        'color: aqua;', // set its fg colo
    binds: [['value', cpu]],
    connections:[[cpu,self => {
        self.tooltipText= 'CPU';
    }]],
    child: Widget.Label({
        style:
        'font-size:10px;',
        binds:[
        ['label', cpu, 'value', value => (Math.round(parseFloat(value.toString())*100)).toString()],
        ]
    }),
});
const ramProgress = Widget.CircularProgress({
   style:
        'min-width: 30px;' + // its size is min(min-height, min-width)
        'min-height: 30px;' +
        'font-size: 7px;' + // to set its thickness set font-size on it
        'margin: 0px;' + // you can set margin on it
        'background-color: #131313;' + // set its bg color
        'color: aqua;', // set its fg colo
    binds: [['value', ram]],
    connections:[[cpu,self => {
        self.tooltipText= `RAM`;
    }]],
    child: Widget.Label({
        style:
        'font-size:10px;',
        binds:[
        ['label', ram, 'value', value => (Math.round(parseFloat(value.toString())*100)).toString()],
        ]
    }),
});
// const label = Widget.Label({
//     binds: [
//         // [propName: string, variable: Variable]
//         // this means that whenever myVar's value changes
//         // Label.label will be updated
//         ['label', cpu],
//
//         // you can specify a transform function like this
//         ['label', cpu, 'value', value => Math.round(value).toString()],
//     ],
//     connections: [
//         // can also be connected to
//         [cpu, self => {
//             self.label = Math.round(cpu.value).toString();
//         }],
//     ],
// });

// layout of the bar
const Left = () => Widget.Box({
    children: [
        Workspaces(),
        ClientTitle(),
    ],
});

const Center = () => Widget.Box({
    children: [
        Media(),
        // Notification(),
    ],
});

const Right = () => Widget.Box({
    halign: 'end',
    children: [
        cpuProgress,
        ramProgress,
        // label,
        Volume(),
        BrightnessWidget(),
        BatteryLabel(),
        Clock(),
        notificationbtn,
        SysTray(),
    ],
});

const Bar = ({ monitor } = {}) => Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    className: 'bar',
    monitor,
    anchor: ['bottom', 'left', 'right'],
    exclusive: true,
    child: Widget.CenterBox({
        startWidget: Left(),
        centerWidget: Center(),
        endWidget: Right(),
    }),
})

// exporting the config so ags can manage the windows
export default {
    style: App.configDir + '/style.css',
    windows: [
        // Bar(),

        NotificationsPopupWindow(),
        NotificationCenter(),
        // applauncher,
        // you can call it, for each monitor
        // Bar({ monitor: 0 }),
        Bar({ monitor: 1 }),
        // Bar({ monitor: 0 }),
    ],
};
