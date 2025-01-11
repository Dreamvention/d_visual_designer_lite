<vd-color-picker>
    <div id="color" class="input-group colorpicker-component fg-color">
        <input type="text" name="{opts.name}" value="{opts.riotValue}" class="form-control" onChange={change}/>
        <span class="input-group-label"><i style="min-width: 17px; min-height: 17px;"></i></span>
    </div>
    <script>
        var d = new Date();
        this.previewColorChange = d.getTime();

        change(e){
            this.opts.evchange(e)
        }

        this.on('mount', function(){
            var that = this;
            var colorPicker = new JSColor($('input', that.root)[0], {
                onChange: function () {
                    var d = new Date();
                    var currentTime = d.getTime();
                    if(currentTime - that.previewColorChange > 500){
                        var event = new Event('change');

                        var d = new Date();
                        that.previewColorChange = d.getTime();
                    }
                }
            });
        });
    </script>
</vd-color-picker>
