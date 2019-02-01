class HALs {
	class Init {
		file = "HALs\Killfeed\Functions";
		class InitModule {postInit = 1;};
	};

	class Display {
		file = "HALs\Killfeed\Functions\Display";
		class CreateKillfeed {};
		class InitKillfeed {};
		class UpdateKillfeed {};
	};

	class EVH {
		file = "HALs\Killfeed\Functions\EVH";
		class UnitSpawned {};
	};

	class System {
		file = "HALs\Killfeed\Functions\System";
		class GetConfigValue {};
		class GetSideColour {};
		class ParseKill {};
	};
};
