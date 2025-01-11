<vd-collapse>
    <div class="vd-collapse {active != ''? 'active' : ''}">
        <div class="vd-collpase-back" ><i class="fas fa-chevron-double-left" onclick={clickBack}></i></div>
        <yield/>
    </div>
    <script>
        this.mixin({store:d_visual_designer})
        this.active = ''
        this.top = this.parent
        this.clickTab = function(e) {
            this.active = e.item.tab
            $(this.parent.root).children('div').hide()
            this.update()
        }.bind(this)
        clickBack = function(e) {
            this.active = ''
            $(this.parent.root).children('div').show()
            this.update()
        }.bind(this)
    </script>
</vd-collapse>