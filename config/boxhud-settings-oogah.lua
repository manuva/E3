-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["RefreshInterval"] = 250;
	["PeerSource"] = "dannet";
	["Colors"] = {
		["Invis"] = {
			[1] = 0.26;
			[2] = 0.98;
			[3] = 0.98;
		};
		["High"] = {
			[1] = 0;
			[2] = 1;
			[3] = 0;
		};
		["True"] = {
			[1] = 0;
			[2] = 1;
			[3] = 0;
		};
		["Low"] = {
			[1] = 1;
			[2] = 0;
			[3] = 0;
		};
		["InZone"] = {
			[1] = 0;
			[2] = 1;
			[3] = 0;
		};
		["Medium"] = {
			[1] = 1;
			[2] = 1;
			[3] = 0;
		};
		["False"] = {
			[1] = 1;
			[2] = 0;
			[3] = 0;
		};
		["NotInZone"] = {
			[1] = 1;
			[2] = 0;
			[3] = 0;
		};
		["DoubleInvis"] = {
			[1] = 0.68;
			[2] = 0.98;
			[3] = 0.98;
		};
		["IVU"] = {
			[1] = 0.95;
			[2] = 0.98;
			[3] = 0.26;
		};
		["Default"] = {
			[1] = 1;
			[2] = 1;
			[3] = 1;
		};
	};
	["Properties"] = {
		["Me.PctHPs"] = {
			["Type"] = "Observed";
			["Name"] = "Me.PctHPs";
		};
		["Target.CleanName"] = {
			["Type"] = "Observed";
			["Name"] = "Target.CleanName";
		};
		["Macro.Name"] = {
			["Type"] = "Observed";
			["Name"] = "Macro.Name";
		};
		["Me.Casting.Name"] = {
			["Type"] = "Observed";
			["Name"] = "Me.Casting.Name";
		};
		["Me.Class.ShortName"] = {
			["Type"] = "Observed";
			["Name"] = "Me.Class.ShortName";
		};
		["Me.PctExp"] = {
			["Type"] = "Observed";
			["Name"] = "Me.PctExp";
		};
		["Me.PctEndurance"] = {
			["Type"] = "Observed";
			["Name"] = "Me.PctEndurance";
		};
		["Me.AAPoints"] = {
			["Type"] = "Observed";
			["Name"] = "Me.AAPoints";
		};
		["Distance3D"] = {
			["Type"] = "Spawn";
			["Name"] = "Distance3D";
		};
		["Me.ActiveDisc.Name"] = {
			["Type"] = "Observed";
			["Name"] = "Me.ActiveDisc.Name";
		};
		["Macro.Paused"] = {
			["Type"] = "Observed";
			["Name"] = "Macro.Paused";
		};
		["Me.Level"] = {
			["Type"] = "Observed";
			["Name"] = "Me.Level";
		};
		["Me.PctMana"] = {
			["Type"] = "Observed";
			["Name"] = "Me.PctMana";
		};
	};
	["DanNetPeerGroup"] = "zone";
	["SchemaVersion"] = 2;
	["Tabs"] = {
		[1] = {
			["Name"] = "General";
			["Columns"] = {
				[1] = "Name";
				[2] = "HP%";
				[3] = "MP%";
				[4] = "EP%";
				[5] = "Distance";
				[6] = "Target";
				[7] = "Spell/Disc";
			};
		};
		[2] = {
			["Name"] = "Macros";
			["Columns"] = {
				[1] = "Name";
				[2] = "Macro";
				[3] = "Paused";
				[4] = "Pause";
				[5] = "End";
			};
		};
		[3] = {
			["Name"] = "XP";
			["Columns"] = {
				[1] = "Name";
				[2] = "Exp%";
				[3] = "AA Unspent";
			};
		};
	};
	["StaleDataTimeout"] = 30;
	["Windows"] = {
		["default"] = {
			["Tabs"] = {
				[1] = "General";
				[2] = "Macros";
				[3] = "XP";
			};
			["Transparency"] = false;
			["PeerGroup"] = "zone";
			["SortDirty"] = true;
			["TitleBar"] = false;
			["Name"] = "default";
			["CurrentTab"] = "General";
		};
	};
	["TitleBar"] = false;
	["Transparency"] = false;
	["Columns"] = {
		["HP%"] = {
			["Name"] = "HP%";
			["InZone"] = false;
			["Ascending"] = true;
			["Type"] = "property";
			["Thresholds"] = {
				[1] = 35;
				[2] = 70;
			};
			["Percentage"] = true;
			["Properties"] = {
				["all"] = "Me.PctHPs";
			};
		};
		["MP%"] = {
			["Name"] = "MP%";
			["InZone"] = false;
			["Ascending"] = true;
			["Type"] = "property";
			["Thresholds"] = {
				[1] = 35;
				[2] = 70;
			};
			["Percentage"] = true;
			["Properties"] = {
				["all"] = "Me.PctMana";
			};
		};
		["Paused"] = {
			["Mappings"] = {
				["FALSE"] = "";
				["TRUE"] = "PAUSED";
			};
			["Name"] = "Paused";
			["Type"] = "property";
			["InZone"] = false;
			["Percentage"] = false;
			["Properties"] = {
				["all"] = "Macro.Paused";
			};
		};
		["Name"] = {
			["InZone"] = false;
			["Type"] = "property";
			["IncludeLevel"] = true;
			["Percentage"] = false;
			["Name"] = "Name";
		};
		["AA Unspent"] = {
			["Name"] = "AA Unspent";
			["InZone"] = false;
			["Ascending"] = false;
			["Type"] = "property";
			["Thresholds"] = {
				[1] = 50;
				[2] = 100;
			};
			["Percentage"] = false;
			["Properties"] = {
				["all"] = "Me.AAPoints";
			};
		};
		["Macro"] = {
			["InZone"] = false;
			["Name"] = "Macro";
			["Type"] = "property";
			["Percentage"] = false;
			["Properties"] = {
				["all"] = "Macro.Name";
			};
		};
		["Target"] = {
			["InZone"] = true;
			["Name"] = "Target";
			["Type"] = "property";
			["Percentage"] = false;
			["Properties"] = {
				["all"] = "Target.CleanName";
			};
		};
		["EP%"] = {
			["Name"] = "EP%";
			["InZone"] = false;
			["Ascending"] = true;
			["Type"] = "property";
			["Thresholds"] = {
				[1] = 35;
				[2] = 70;
			};
			["Percentage"] = true;
			["Properties"] = {
				["all"] = "Me.PctEndurance";
			};
		};
		["Exp%"] = {
			["Name"] = "Exp%";
			["InZone"] = false;
			["Ascending"] = true;
			["Type"] = "property";
			["Thresholds"] = {
				[1] = 33;
				[2] = 66;
			};
			["Percentage"] = true;
			["Properties"] = {
				["all"] = "Me.PctExp";
			};
		};
		["End"] = {
			["Type"] = "button";
			["Action"] = "/dex #botName# /end";
			["Name"] = "End";
		};
		["Distance"] = {
			["Name"] = "Distance";
			["InZone"] = true;
			["Ascending"] = false;
			["Type"] = "property";
			["Thresholds"] = {
				[1] = 100;
				[2] = 200;
			};
			["Percentage"] = false;
			["Properties"] = {
				["all"] = "Distance3D";
			};
		};
		["Spell/Disc"] = {
			["InZone"] = false;
			["Name"] = "Spell/Disc";
			["Type"] = "property";
			["Percentage"] = false;
			["Properties"] = {
				["melee"] = "Me.ActiveDisc.Name";
				["all"] = "Me.Casting.Name";
			};
		};
		["Pause"] = {
			["Type"] = "button";
			["Action"] = "/dex #botName# /mqp";
			["Name"] = "Pause";
		};
	};
}
return obj1
