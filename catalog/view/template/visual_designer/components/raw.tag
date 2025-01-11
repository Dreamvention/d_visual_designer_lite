<raw>
    <div></div>
    <script>
        this.mixin({store:d_visual_designer})
        this.set = function(){
            $(this.root).html(opts.html)
        }
        this.on('update', this.set)
        this.on('mount', this.set)
    </script>
</raw>