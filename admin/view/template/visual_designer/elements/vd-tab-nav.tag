<vd-tab-nav>
    <div class="vd-style-tab">
        <div each="{tab in opts.tabs}" class="vd-style-tab-item {tab.type == active? 'active' : ''}" data-type="{tab.type}" onclick="{click}">{tab.name}</div>
    </div>
    <div class="vd-style-tab-content">
        <virtual each="{tab in opts.tabs}">
            <div class="vd-style-tab-item {tab.type == active ? 'active' : ''}">
                <div data-is="{tab.is}" params="{tab.opts}"/>
            </div>
        </virtual>

    </div>
    <script>
        this.active = _.first(opts.tabs).type

        click(e)
        {
            this.active = $(e.currentTarget).data('type')
            this.update()
        }
    </script>
</vd-tab-nav>