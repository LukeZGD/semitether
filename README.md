# semitether

- For iPad 2 4.3.x semi-tethered jailbreaking
- Not sure what to call this, I guess "g1lbertlite" ???
- The "jailbreak" is just powered by [dora's fork of iBoot32Patcher](https://github.com/dora2ios/iBoot32Patcher) and [comex's kernel patcher](https://github.com/comex/datautils0)
- Implemented in [Legacy iOS Kit](https://github.com/LukeZGD/Legacy-iOS-Kit)

Manual preparation:

- NOTE: The notes below are for users who know what they're doing. If you just want to jailbreak, just use Legacy iOS Kit
- Get 4.3.x iBSS, decrypt with xpwntool, patch with iBoot32Patcher with `--rsa` and bootargs `-v cs_enforcement_disable=1`, leave it unpacked
- Get 4.3.x kernelcache, decrypt with xpwntool, bspatch with the correct patch in the `patches` folder, repack with xpwntool

Booting:

- NOTE: This is for booting only. This does not install the bootstrap, do that separately with an SSH ramdisk
- Pwn the device with synackuk checkm8-a5
- Send unpacked iBSS with synackuk ipwndfu
- Send devicetree and run command `devicetree` with irecovery
- Send kernelcache and run command `bootx` with irecovery
