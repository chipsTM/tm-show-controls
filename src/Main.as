Json::Value@ config;

void GetPluginConfig(const string &in configName) {
    auto req = Net::HttpGet("https://openplanet.dev/plugin/showcontrols/config/" + configName);
    while (!req.Finished()) {
        yield();
    }
    if (req.ResponseCode() == 200) {
        @config = req.Json();
    } else {
        throw("failed to load plugin config. falling back to local file");
    }
}

void Main() {
    CTrackMania@ app = cast<CTrackMania@>(GetApp());


    try {
        GetPluginConfig("controls");
    } catch  {
        error(getExceptionInfo());
        @config = Json::FromFile("src/config.json");
    }

    while(true) {
        yield();
        if (app.ManiaPlanetScriptAPI is null) continue;
        if (app.InputPort is null) continue;
        
        array<string> bound_controls;
        auto mpsa = app.ManiaPlanetScriptAPI;
        auto pads = app.InputPort.Script_Pads;
        for (uint i = 0; i < pads.Length; i++) {
            mpsa.InputBindings_UpdateList(CGameManiaPlanetScriptAPI::EInputsListFilter::All, pads[i]);
            auto actions = mpsa.InputBindings_ActionNames;
            auto bindings = mpsa.InputBindings_Bindings;
            auto bindings_raw = mpsa.InputBindings_BindingsRaw;
            
            bound_controls.InsertLast("\\$0FF" + pads[i].ModelName + "\\$z:");
            for (uint j = 0; j < bindings.Length; j++) {
                string b = string(bindings[j]);
                string a = string(actions[j]).Replace("|Input|", "");
                string br = string(bindings_raw[j]);
                if (b == "" && !showUnbound) continue;
                bound_controls.InsertLast(a + ":" + b);
            }
        }
        config[0]["controls"] = bound_controls;

        sleep(15000);
    }
}