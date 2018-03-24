class HALs {
	class init {
		file = "Killfeed\Functions";
		class initModule {postInit = 1;};
	};
	class client {
		file = "Killfeed\Functions\Client";
		class initKillfeed {};
		class onUnitSpawned {};
		class getSideColour {};
		class parseKill {};
	};
	class display {
		file = "Killfeed\Functions\Display";
		class createKillfeed {};
		class updateKillfeed {};
	};
};
