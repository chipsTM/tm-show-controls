void RenderSubTable(const string &in title, Json::Value@ controls) {
    UI::PushStyleVar(UI::StyleVar::CellPadding, vec2(20,0));
    UI::Text(title);
    UI::Separator();
    UI::BeginTable(title + "Table", 2, UI::TableFlags::SizingStretchProp|UI::TableFlags::RowBg);
    UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0, 0.0, 0.0, 0.5));
    for (uint i = 0; i < controls.Length; i++) {
        auto parts = string(controls[i]).Split(":", 2);
        UI::TableNextColumn();
        UI::Text(parts[0]);
        UI::TableNextColumn();
        UI::Text(parts[1]);
        UI::TableNextRow();
    }
    UI::PopStyleColor();
    UI::EndTable();
    UI::PopStyleVar();
}


void RenderMenuMain() {
    if (UI::BeginMenu("Controls")) {
        UI::BeginTable("Table", config.Length, UI::TableFlags::SizingStretchSame|UI::TableFlags::BordersInnerV);
        for (uint i = 0; i < config.Length; i++) {
            UI::TableNextColumn();
            RenderSubTable(config[i]["section"], config[i]["controls"]);
        }
        UI::EndTable();
        UI::Separator();
        UI::Text("@chips_tm on the Openplanet discord for any corrections");
        UI::EndMenu();
    }
}