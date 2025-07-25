/* Taken from https://github.com/djpohly/dwl/issues/466 */
#include <xkbcommon/xkbcommon-keysyms.h>
#define COLOR(hex)                                                             \
  {((hex >> 24) & 0xFF) / 255.0f, ((hex >> 16) & 0xFF) / 255.0f,               \
   ((hex >> 8) & 0xFF) / 255.0f, (hex & 0xFF) / 255.0f}
/* appearance */
static const int sloppyfocus = 0;       /* focus follows mouse */
static const int mousefollowsfocus = 1; /* mouse follows focus */
static const int bypass_surface_visibility =
    0; /* 1 means idle inhibitors will disable idle tracking even if it's
          surface isn't visible  */
static const unsigned int borderpx = 1; /* border pixel of windows */
static const float bordercolor[] = {0.5, 0.5, 0.5, 1.0};
static const float focuscolor[] = {1.0, 0.0, 0.0, 1.0};
static const float urgentcolor[] = COLOR(0xff0000ff);
static const float rootcolor[] = COLOR(0x2596be);
/* To conform the xdg-protocol, set the alpha to zero to restore the old
 * behavior */
static const float fullscreen_bg[] = {0.1, 0.1, 0.1, 1.0};
/* tagging - tagcount must be no greater than 31 */
#define TAGCOUNT (9)
static const int tagcount = TAGCOUNT;

static const Rule rules[] = {
    /* app_id     title       tags mask     isfloating   monitor */
    {"notetaker", NULL, -1, 1, -1},
};

/* logging */
static int log_level = WLR_ERROR;

/* layout(s) */
static const Layout layouts[] = {
    /* symbol     arrange function */
    {"[]=", tile},
    {"><>", NULL}, /* no layout function means floating behavior */
    {"[M]", monocle},
    {"|M|", centeredmaster},
};

/* monitors */
static const MonitorRule monrules[] = {
    /* name       mfact nmaster scale layout       rotate/reflect x    y */
    /* example of a HiDPI laptop monitor:
    { "eDP-1",    0.5,  1,      2,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,
    -1,  -1 },
    */
    /* defaults */
    {NULL, 0.55, 1, 1, &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL, -1, -1},
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
    /* can specify fields: rules, model, layout, variant, options */
    /* example:
    .options = "ctrl:nocaps",
    */
    .options = "grp:alt_shift_toggle",
    .layout = "us,ru",
};

static const int repeat_rate = 40;
static const int repeat_delay = 300;

/* Trackpad */
static const int tap_to_click = 1;
static const int tap_and_drag = 1;
static const int drag_lock = 1;
static const int natural_scrolling = 0;
static const int disable_while_typing = 1;
static const int left_handed = 0;
static const int middle_button_emulation = 0;
/* You can choose between:
LIBINPUT_CONFIG_SCROLL_NO_SCROLL
LIBINPUT_CONFIG_SCROLL_2FG
LIBINPUT_CONFIG_SCROLL_EDGE
LIBINPUT_CONFIG_SCROLL_ON_BUTTON_DOWN
*/
static const enum libinput_config_scroll_method scroll_method =
    LIBINPUT_CONFIG_SCROLL_2FG;

/* You can choose between:
LIBINPUT_CONFIG_CLICK_METHOD_NONE
LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS
LIBINPUT_CONFIG_CLICK_METHOD_CLICKFINGER
*/
static const enum libinput_config_click_method click_method =
    LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS;

/* You can choose between:
LIBINPUT_CONFIG_SEND_EVENTS_ENABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED_ON_EXTERNAL_MOUSE
*/
static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;

/* You can choose between:
LIBINPUT_CONFIG_ACCEL_PROFILE_FLAT
LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE
*/
static const enum libinput_config_accel_profile accel_profile =
    LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;
/* You can choose between:
LIBINPUT_CONFIG_TAP_MAP_LRM -- 1/2/3 finger tap maps to left/right/middle
LIBINPUT_CONFIG_TAP_MAP_LMR -- 1/2/3 finger tap maps to left/middle/right
*/
static const enum libinput_config_tap_button_map button_map =
    LIBINPUT_CONFIG_TAP_MAP_LRM;

/* If you want to use the windows key for MODKEY, use WLR_MODIFIER_LOGO */
#define MODKEY WLR_MODIFIER_LOGO

#define TAGKEYS(KEY, SKEY, TAG)                                                \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
      {MODKEY | WLR_MODIFIER_CTRL, KEY, toggleview, {.ui = 1 << TAG}},         \
      {MODKEY | WLR_MODIFIER_SHIFT, SKEY, tag, {.ui = 1 << TAG}}, {            \
    MODKEY | WLR_MODIFIER_CTRL | WLR_MODIFIER_SHIFT, SKEY, toggletag, {        \
      .ui = 1 << TAG                                                           \
    }                                                                          \
  }

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                       \
  }

/* commands */
static const char *termcmd[] = {"foot", NULL};
static const char *menucmd[] = {"bemenu-run", NULL};
static const char *qutebrowsercmd[] = {"qutebrowser", NULL};

static const char *const autostart[] = {
    "sh",
    "-c",
    "gammastep -l 59.4716181:24.5981628 -t 6500:2000 -b 1:0.4",
    NULL,
    "sh",
    "-c",
    "swayidle -w timeout 1500 'systemctl suspend'",
    NULL,
    "sh",
    "-c",
    "i3status | dwlb -status-stdin all",
    NULL,
    "dunst",
    NULL,
    NULL
};

static const Key keys[] = {
    /* Note that Shift changes certain key codes: c -> C, 2 -> at, etc. */
    /* modifier                  key                 function        argument */
    {MODKEY, XKB_KEY_d, spawn, {.v = menucmd}},
    {MODKEY, XKB_KEY_Return, spawn, {.v = termcmd}},
    {MODKEY, XKB_KEY_w, spawn, {.v = qutebrowsercmd}},
    {
        MODKEY, XKB_KEY_n, spawn,
        SHCMD("/usr/bin/foot -a notetaker -e $HOME/.bin/notetaker")
    },
    {
        MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_L, spawn,
        SHCMD("/usr/bin/swaylock -c '000000'")
    },
    {MODKEY, XKB_KEY_q, killclient, {0}},
    {MODKEY, XKB_KEY_j, focusstack, {.i = +1}},
    {MODKEY, XKB_KEY_k, focusstack, {.i = -1}},
    {MODKEY, XKB_KEY_i, incnmaster, {.i = +1}},
    {MODKEY, XKB_KEY_o, incnmaster, {.i = -1}},
    {MODKEY, XKB_KEY_h, setmfact, {.f = -0.05}},
    {MODKEY, XKB_KEY_l, setmfact, {.f = +0.05}},
    {MODKEY, XKB_KEY_c, setlayout, {.v = &layouts[3]}},
    {MODKEY, XKB_KEY_z, zoom, {0}},
    {MODKEY, XKB_KEY_Tab, view, {0}},
    {MODKEY, XKB_KEY_t, setlayout, {.v = &layouts[0]}},
    //    {MODKEY, XKB_KEY_f, setlayout, {.v = &layouts[1]}},
    {MODKEY, XKB_KEY_m, setlayout, {.v = &layouts[2]}},
    {MODKEY, XKB_KEY_space, setlayout, {0}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_space, togglefloating, {0}},
    {MODKEY, XKB_KEY_f, togglefullscreen, {0}},
    {MODKEY, XKB_KEY_0, view, {.ui = ~0}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_parenright, tag, {.ui = ~0}},
    {MODKEY, XKB_KEY_g, focusmon, {.i = WLR_DIRECTION_LEFT}},
    {MODKEY, XKB_KEY_y, focusmon, {.i = WLR_DIRECTION_RIGHT}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_G, tagmon, {.i = WLR_DIRECTION_LEFT}},
    {
        MODKEY | WLR_MODIFIER_SHIFT,
        XKB_KEY_Y,
        tagmon,
        {.i = WLR_DIRECTION_RIGHT}
    },
    {MODKEY, XKB_KEY_period, spawn, SHCMD("playerctl next")},
    {MODKEY, XKB_KEY_comma, spawn, SHCMD("playerctl previous")},
    {MODKEY, XKB_KEY_comma, spawn, SHCMD("playerctl previous")},
    {MODKEY, XKB_KEY_p, spawn, SHCMD("playerctl play-pause")},
    TAGKEYS(XKB_KEY_1, XKB_KEY_exclam, 0),
    TAGKEYS(XKB_KEY_2, XKB_KEY_at, 1),
    TAGKEYS(XKB_KEY_3, XKB_KEY_numbersign, 2),
    TAGKEYS(XKB_KEY_4, XKB_KEY_dollar, 3),
    TAGKEYS(XKB_KEY_5, XKB_KEY_percent, 4),
    TAGKEYS(XKB_KEY_6, XKB_KEY_asciicircum, 5),
    TAGKEYS(XKB_KEY_7, XKB_KEY_ampersand, 6),
    TAGKEYS(XKB_KEY_8, XKB_KEY_asterisk, 7),
    TAGKEYS(XKB_KEY_9, XKB_KEY_parenleft, 8),
    {
        MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_Q, spawn,
        SHCMD("/usr/bin/foot -a notetaker -e $HOME/.bin/morning-questions")
    },

    /* Ctrl-Alt-Backspace and Ctrl-Alt-Fx used to be handled by X server */

#define CHVT(n)                                                                \
  {                                                                            \
    WLR_MODIFIER_CTRL | WLR_MODIFIER_ALT, XKB_KEY_XF86Switch_VT_##n, chvt, {   \
      .ui = (n)                                                                \
    }                                                                          \
  }
    CHVT(1),
    CHVT(2),
    CHVT(3),
    CHVT(4),
    CHVT(5),
    CHVT(6),
    CHVT(7),
    CHVT(8),
    CHVT(9),
    CHVT(10),
    CHVT(11),
    CHVT(12),
};

static const Button buttons[] = {
    {MODKEY, BTN_LEFT, moveresize, {.ui = CurMove}},
    {MODKEY, BTN_MIDDLE, togglefloating, {0}},
    {MODKEY, BTN_RIGHT, moveresize, {.ui = CurResize}},
