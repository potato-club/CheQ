package dev.oth.cheq.base;

import java.util.ArrayList;
import java.util.List;

/**
 * @Creator: isaacJang-dev
 * @Date: 2023-01-19
 */
public class DEFINE {

    public static String URL_BASE = "https://www.naver.com";

    public static String getCheqUrl() {
        return URL_BASE;
    }

    public static final String URL_RECIEVE_PUSH = "/push/v1/device/check/receive";

    public static final String VUE_BRIDGE = "app";

    public static final String MENU_CLOSE_BTN_CLASS = "gnb_close";
    public static String getMenuCloseOrder() {
        return "document.getElementsByClassName('"+ DEFINE.MENU_CLOSE_BTN_CLASS + "')[0].click();";
    }
    public static final String ROUTER_BACK_BTN_CLASS = "btn_back";
    public static String getRouterBackOrder() {
        return "document.getElementsByClassName('"+ DEFINE.ROUTER_BACK_BTN_CLASS + "')[0].click();";
    }


    public static final String REFRESH_BY_DIALOG_JS_CODE =
            "var app_value_body_element = document.getElementsByTagName('body')[0];\n" +
                    "  function appFuncPopupIdChecker() {\n" +
                    "    var divs = app_value_body_element.getElementsByTagName(\"div\");\n" +
                    "    for (div of divs) {\n" +
                    "      let id = div.getAttribute('id') || '-';\n" +
                    "      if (id.indexOf('dialog') > -1) {\n" +
                    "        return true;\n" +
                    "      };\n" +
                    "    };\n" +
                    "    return false;\n" +
                    "  };\n" +
                    "\n" +
                    "  var app_value_observer_delay = false\n" +
                    "\n" +
                    "  var app_value_observer = new MutationObserver(function(mutations) {\n" +
                    "    mutations.forEach(function(mutation) {\n" +
                    "      if (app_value_observer_delay) {\n" +
                    "        return\n" +
                    "      }\n" +
                    "      app_value_observer_delay = true\n" +
                    "      window.dreams.refreshAble(`{\"type\":\"off\"}`)\n" +
                    "      //call block refresh -> android bridge call ( diable refresh )\n" +
                    "      setTimeout(function() {\n" +
                    "        if (appFuncPopupIdChecker()) {\n" +
                    "          window.dreams.refreshAble(`{\"type\":\"off\"}`)\n" +
                    "        }\n" +
                    "        else {\n" +
                    "          window.dreams.refreshAble(`{\"type\":\"on\"}`)\n" +
                    "        }\n" +
                    "        app_value_observer_delay = false;\n" +
                    "        //choose refresh block -> android bridge call ( disable or enable refresh)\n" +
                    "      }, 1000);\n" +
                    "    });\n" +
                    "  });\n" +
                    "\n" +
                    "  app_value_observer.observe(app_value_body_element, {\n" +
                    "    attributes: true\n" +
                    "  });";
}
