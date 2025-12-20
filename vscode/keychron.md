Go to: https://launcher.keychron.com/#/keymap

Caps Lock = LT(1, KC_ESC)

# Layer 1:
- Gán cho phím Q
LGUI(LALT(KC_ESC))

T = Tmux Prefix: C(KC_B)
0 = Home
4 = End
A = LGUI(LSFT(KC_C))
I = Shift + F12	S(KC_F12)	Find References
O = LALT(LSFT(KC_F12)) Find All References
u = pgup
d = pgdown
r = f16 -> vscode open recent
m = command + k command + m -> maximize editor group
f = (ctrl + command + f): C(G(KC_F)) -> Full window
Caplock = Caplock
enter = Command + K Z -> Toggle Zen mode
- Chức năng: Chuyển Tab Trái / Tab Phải.
- Phím tắt gốc (macOS): Cmd + Shift + [ và Cmd + Shift + ]
- Mapping:
[ (Prev Tab): LGUI(S(KC_LBRC))
] (Next Tab): LGUI(S(KC_RBRC))
G = (Command + K): LGUI(KC_K)
Space = C(KC_B)

Để tạo phím tắt `Control + `` (Backtick) trên VIA cho bàn phím Keychron, bạn sử dụng mã QMK trong phần Any.
Mã QMK cần dùng: LCTL(KC_GRV)
Add new key

# Layer 3

- (Win Mode): Space = LCTL(KC_K)
- Space = C(KC_B)