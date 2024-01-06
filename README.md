# semitether

- For iPad 2 4.3.x semi-tethered jailbreaking
- Not sure what to call this, I guess "g1lbertlite" ???
- The "jailbreak" is just powered by iBoot32Patcher and comex's kernel patcher
- Implemented in [Legacy iOS Kit](https://github.com/LukeZGD/Legacy-iOS-Kit)

Manual preparation:

- NOTE: The notes below are for users who know what they're doing. If you just want to jailbreak, just use Legacy iOS Kit
- Get 6.1.3 iBSS, decrypt with xpwntool, patch with iBoot32Patcher with `--rsa`, repack with xpwntool
- Get 4.3.x iBEC, decrypt with xpwntool, patch with iBoot32Patcher with `--rsa` and bootargs `-v cs_enforcement_disable=1`, repack with xpwntool
- Get 4.3.x kernelcache, decrypt with xpwntool, bspatch with the patch in the `patches` folder, repack with xpwntool

Booting:

- NOTE: This is for booting only. This does not install the bootstrap, do that separately with an SSH ramdisk
- Pwn the device with synackuk checkm8-a5
- Send iBSS with synackuk ipwndfu
- Send iBEC with irecovery
- Send devicetree and run command `devicetree` with irecovery
- Send kernelcache and run command `bootx` with irecovery
