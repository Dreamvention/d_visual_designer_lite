<vd-icon-picker>
    <div class="input-group vd-icon-group-control">
        <div class="input-group-text"><i class="{opts.riotValue}"></i></div>
        <input type="text" class="form-control" name="{opts.name}" value="{opts.riotValue}" oninput={inputFilter} onChange={changeFilter}>
        <div class="input-group-btn">
            <button type="button" onclick={clickCollapse} class="btn-collapse btn btn-light">
                <i class="far fa-angle-down" if="{!open}"></i>
                <i class="far fa-angle-up" if="{open}"></i>
            </button>
        </div>
    </div>
    <div class="vd-icon-picker-wrapper" if={open}>
        <virtual each={icon in icons}>
            <div class="vd-icon-element {opts.riotValue == icon?  'active': ''}" onclick={clickIcon}>
                <span  class="{icon}"></span>
            </div>
        </virtual>
    </div>
    <script>
        this.library = this.opts.library
        this.icons = window.iconset[this.opts.library]
        this.open = false
        this.loading = false
        this.filter = ''
        clickCollapse(e) {
            this.open = !this.open
        }
        clickIcon(e){
            var event = {}
            event.currentTarget = event.target = {name: this.opts.name, value: e.item.icon}
            this.opts.evchange(event)
        }.bind(this)
        this.on('update', function(e){
            if(this.library !== this.opts.library) {
                this.library = this.opts.library
                this.icons = window.iconset[this.opts.library]
            }
        })
        inputFilter(e) {
            if(e.currentTarget.value != ''){
                this.icons =_.filter(window.iconset[this.opts.library], function(value){
                    return value.indexOf(e.currentTarget.value) != -1
                }.bind(this))
            } else {
                this.icons = window.iconset[this.opts.library]
            }
        }
        changeFilter(e) {
            this.opts.evchange(e)
        }
    </script>
</vd-icon-picker>
