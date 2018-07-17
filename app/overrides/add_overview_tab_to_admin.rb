Deface::Override.new(virtual_path: 'spree/admin/shared/_tabs',
                     name: 'admin_overview_tab',
                     insert_bottom: "[data-hook='admin_tabs']",
                     partial: 'spree/shared/overview_sub_menu',
                     disabled: false)
