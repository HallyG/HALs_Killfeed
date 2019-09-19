class HALs_killfeed {
	class Init {
		file = "HALs\Addons\killfeed\functions";
		class initClient {};
		class initModule {/*postInit = 1;*/};
	};

    class Client {
        file = "HALs\Addons\killfeed\functions\client";
		class eachFrame {headerType = -1;};
		class parseKill {};
		class updateKillfeed {};
    };
};
