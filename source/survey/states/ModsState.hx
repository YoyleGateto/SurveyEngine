import survey.visuals.ModBox;
import sys.FileSystem;
import survey.options.*;
import core.game.ConfigState;

class ModsState extends State
{
	var boxGrp:FlxTypedGroup<FlxSprite>;
	var mods:Array;
	var sel:Int;
	var soul:FlxSprite;
	
	var optionsGrp:Array<BaseOption>;
	var optSel:Int;
	var creatorCam:Camera;
	var creationMenu:Bool;
	var modData:Dynamic;
	var creationMenu:Bool;
	
	override function create() {
		super.create();
		// MODS MENU
	
		creationMenu = false;
		sel = 0;
		optSel = 0;
		modData = {
			name: "",
			author: "",
			useSaveFiles: false
		};//"
		creationMenu = false
		optionsGrp = [
			new InputOption("Name", modData, "name"),
			new InputOption("Author", modData, "author"),
			new BoolOption("Use Save Files", 1, 1, 5, modData, "useSaveFiles"),
			new TextOption("Done", () -> if (modData.name != null && modData.name.length > 0) {
				sel = 0;
				change();
				FlxTimer.wait(0.1, () -> creationMenu = false);
				FlxTween.tween(creatorCam.scroll, {
					x: -FlxG.width,
				}, 0.25, {ease: FlxEase.cubeOut});
				FlxTween.tween(FlxG.camera.scroll, {
					x: 0,
				}, 0.25, {ease: FlxEase.cubeOut});
				
				mods.insert(0, modData.name);
				boxGrp.insert(0, new ModBox(0,0,modData.name));
				for (i => spr in boxGrp) {
					spr.y = 15 + (65*i);
					spr.screenCenter(FlxAxes.X);
				}
				
				var path = Paths.mods + "/" + modData.name;
				FileSystem.createDirectory(path);
				File.saveContent(path + "/meta.json", Json.stringify(modData));
				
				Utility.playSound("menu/confirm", 1);
			}),
		];
		
		boxGrp = new FlxTypedGroup<FlxSprite>();
		add(boxGrp);
		
		mods = [];
		if (FileSystem.exists(Paths.mods))
		        if (FileSystem.isDirectory(Paths.mods))
		            for (mod in FileSystem.readDirectory(Paths.mods))
		                if (FileSystem.isDirectory(Paths.mods + '/' + mod) && mod != '.git')
		                    mods.push(mod);
		
		mods.push(null);
		mods.push(0);
		
		for (i => mod in mods) {
			var spr = new ModBox(0, 15 + (65*i), mod);
			spr.screenCenter(X);
			boxGrp.add(spr);
		}
		
		soul = new FlxSprite().loadGraphic(Paths.image('soul/heart_menu'));
		soul.color = FlxColor.RED;
		soul.scale.set(2, 2);
		soul.updateHitbox();
		add(soul);
		
		if (boxGrp.members[0] != null) {
			soul.x = boxGrp.members[0].x + 14;
			soul.y = boxGrp.members[0].y + 18;
		}
		
		// CREATOR MENU
		
		creatorCam = new Camera();
		creatorCam.bgColor = 0;
		FlxG.cameras.add(creatorCam, false);
		creatorCam.scroll.x = -FlxG.width;
		
		soul2 = new FlxSprite().loadGraphic(Paths.image('soul/heart_menu'));
		soul2.color = FlxColor.RED;
		soul2.scale.set(2, 2);
		soul2.updateHitbox();
		soul2.cameras = [creatorCam];
		add(soul2);
		
		for (i=>opt in optionsGrp) {
			opt.x = 64;
			opt.y = 96 + (30*i);
			opt.cameras = [creatorCam];
			add(opt);
		}
		
		if (optionsGrp[0] != null) {
			soul2.x = optionsGrp[0].x - 24;
			soul2.y = optionsGrp[0].y + 8;
		}
	}

	function change(?n:Int = 0) {
		sel = FlxMath.wrap(sel + n, 0, mods.length - 1);
		if (boxGrp.members[sel] != null) {
			FlxTween.tween(soul, {
				x: boxGrp.members[sel].x + 14,
				y: boxGrp.members[sel].y + 18,
			}, 0.25, {ease: FlxEase.cubeOut});
			FlxTween.tween(FlxG.camera.scroll, {
				y: (Math.max(sel - 6, 0) * 70)
			}, 0.25, {ease: FlxEase.cubeOut});
		}
		Utility.playSound("menu/scroll", 1);
	}

	function changeCr(?n:Int = 0) {
		optSel = FlxMath.wrap(optSel + n, 0, optionsGrp.length - 1);
		if (boxGrp.members[sel] != null) {
			FlxTween.tween(soul2, {
				x: optionsGrp[optSel].x - 24,
				y: optionsGrp[optSel].y + 8,
			}, 0.25, {ease: FlxEase.cubeOut});
		}
		Utility.playSound("menu/scroll", 1);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		
		var c = Math.sin(FlxG.game.ticks / 1000) * 255;
		FlxG.camera.bgColor = FlxColor.fromRGB(0,0,c/4);
		for (i => spr in boxGrp.members) {
			spr.alpha = (i == sel) ? 1 : 0.75;
			spr.color = switch(spr.mod) {
				case 0: FlxColor.LIME;
				default: FlxColor.WHITE;
			};
		}
		if (!creationMenu) {
			if (Keys.DOWN_P) {
				change(1);
			}
			if (Keys.UP_P) {
				change(-1);
			}
			if (Keys.ACCEPT_P) {
				var mod = mods[sel];
				Utility.playSound("menu/confirm", 1);
				if (mod == 0) {
					modData = {
						name: "",
						author: "",
						useSaveFiles: false
					};//"
					for (opt in optionsGrp) {
						opt.save = modData;
						opt.load();
					}
					creationMenu = true;
					FlxTween.tween(FlxG.camera.scroll, {
						x: FlxG.width,
					}, 0.25, {ease: FlxEase.cubeOut});
					FlxTween.tween(creatorCam.scroll, {
						x: 0,
					}, 0.25, {ease: FlxEase.cubeOut});
				} else {
					final save:FlxSave = new FlxSave();
                
	                save.bind('SURVEY_DATA', utils.cool.FileUtil.getSavePath(false));
	
	                save.data.currentMod = mod;
					
					CoolUtil.switchState(new ConfigState(), false, true);
				}
			}
		} else {
			var sel = optionsGrp[optSel];
			
			if (sel == null) return;
			
			if (sel.selected) {
				if (Keys.LEFT_P)
					sel.change(-1);
				if (Keys.RIGHT_P)
					sel.change(1);
				if ((Keys.BACK_P && sel.canInput == null) || (sel.canInput != null && !sel.canInput)) {
					Utility.playSound("menu/cancel", true);
					sel.selected = false;
					if (sel != null) {
						FlxTween.tween(soul2, {
							x: sel.x - 24,
							y: sel.y + 8,
						}, 0.25, {ease: FlxEase.cubeOut});
					}
					return;
				}
			} else {
				if (Keys.ACCEPT_P) {
					if (sel.callback != null) {
						sel.callback();
						return;
					} else {
						Utility.playSound("menu/confirm", true);
						sel.selected = true;
						if (sel != null) {
							FlxTween.tween(soul2, {
								x: (sel.x + 320) - 24,
								y: sel.y + 8,
							}, 0.25, {ease: FlxEase.cubeOut});
						}
					}
				}
				if (Keys.UP_P)
					changeCr(-1);
				if (Keys.DOWN_P)
					changeCr(1);
				if (Keys.BACK_P) {
					creationMenu = false;
					FlxTween.tween(creatorCam.scroll, {
						x: -FlxG.width,
					}, 0.25, {ease: FlxEase.cubeOut});
					FlxTween.tween(FlxG.camera.scroll, {
						x: 0,
					}, 0.25, {ease: FlxEase.cubeOut});
					Utility.playSound("menu/cancel", 1);
				}
			}
		}
	}
}