# Cordelia cue
Cordelia cue is an extension of Cordelia designed for a specific purpose.
The idea is creating the simplest cue list conceivable.

# Requirements
Vim or Neovim, Csound, Python

# Exemple

```
;---     0-PROLOGUE
; ================================
start:  "0-PROLOGUE", fadeout=5
;---
;end:	"0-PROLOGUE"
;---
start:  "0-PROLOGUE-souffle-1", fadeout=5, dyn=.5
;---
start:  "0-PROLOGUE-souffle-2", fadeout=5, dyn=.5
end:    "0-PROLOGUE-souffle-1"
;---
start:  "0-PROLOGUE-souffle-3", fadeout=5, dyn=.5
end:    "0-PROLOGUE-souffle-2"
;---
start:  "0-PROLOGUE-souffle-4", fadeout=5, dyn=.5
end:    "0-PROLOGUE-souffle-3"
;---
	$aphrodite_start
```

This is a Cordelia-cue code exemple.

Pressing the space tab, advance the cuelist to the next `;---` event.

Keywords options:

- `start_from <int sec>`
- `when <int sec>`
- `loop <boolean 0 or 1>`
- `dyn <float 0, 1>`
- `fade[in - out] <int sec>`
- `fade[in - out]_mode <LIN, COS, EXP>`