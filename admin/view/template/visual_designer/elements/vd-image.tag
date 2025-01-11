<vd-image>
    <a href="" id="thumb-vd-image" data-toggle="vd-image" class="img-thumbnail">
        <img src="{opts.thumb}" alt="" title="" width="100px" height="100px" data-placeholder="{!_.isUndefined(opts.placeholder) ? opts.placeholder : store.getOptions('designer.placeholder')}"/>
    </a>
    <input type="hidden" name="{opts.name}" value="{opts.value}" id="input-vd-image"  onChange={change}/>
    <script>
        this.mixin({store: d_visual_designer})
        change(e) {
            this.opts.evchange(e)
        }
    </script>
</vd-image>
