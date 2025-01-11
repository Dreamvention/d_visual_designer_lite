<vd-collapse-item>
    <div class="vd-collapse-title" onclick={parent.clickTab}>{opts.title}</div>
    <div class="vd-collapse-content {parent.active == tab ? 'active' : null}"><yield/></div>
    <script>
        this.mixin({store:d_visual_designer})
        this.top = this.parent.top
    </script>
</vd-collapse-item>