<vd-range>
    <div class="range">
        <input type="range" step="{step}" min="{min}" max="{max}" name="{opts.name}_range" value="{rangeValue}" disabled={opts.riotValue == ''} onChange={changeRange} onInput={changeRange}>
        <input type="text" class="form-control" name="{opts.name}" value="{getFullText()}" onchange={change}/>
    </div>
    <script>
        var d = new Date();
        this.rangeValue = this.opts.riotValue
        this.step = this.opts.step
        this.max = this.opts.max
        this.min = this.opts.min
        this.previewRangeChange = d.getTime();

        this.getFullText = function(){
            var er = /^-?[0-9]+$/;
            if(er.test(this.opts.riotValue)){
                return this.opts.riotValue+'px'
            }
            return this.opts.riotValue
        }
        
        this.initValue = function() {
          var rangeValue = this.opts.riotValue
          rangeValue = rangeValue.replace('px', '').replace('rem', '').replace('em', '')
          this.rangeValue = rangeValue
        }
        
        this.initStep = function() {
          var step = this.opts.step
          var remTest = /^-?[0-9.,]+(rem)$/
          var emTest = /^-?[0-9]+(em)$/
          var pxTest = /^-?[0-9]+(px)$/
          if(!this.opts.step) {
            if(remTest.test(this.opts.riotValue)){
              step = 0.1
            }
            if(emTest.test(this.opts.riotValue)){
              step = 0.1
            }
            if(pxTest.test(this.opts.riotValue)){
              step = 1
            }
          }
          this.step = step
        }
        this.initMax = function() {
          var max = this.opts.max
          var remTest = /^-?[0-9.,]+(rem)$/
          var emTest = /^-?[0-9.,]+(em)$/
          var pxTest = /^-?[0-9]+(px)$/
          if(!this.opts.max) {
            if(remTest.test(this.opts.riotValue)){
              max = 10
            }
            if(emTest.test(this.opts.riotValue)){
              max = 10
            }
            if(pxTest.test(this.opts.riotValue)){
              max = 100
            }
          }
          this.max = max
        }
        this.initMin = function() {
          var min = this.opts.min
          var remTest = /^-?[0-9.,]+(rem)$/
          var emTest = /^-?[0-9.,]+(em)$/
          var pxTest = /^-?[0-9]+(px)$/
          if(!this.opts.min) {
            if(remTest.test(this.opts.riotValue)){
              min = 0.1
            }
            if(emTest.test(this.opts.riotValue)){
              min = 0.1
            }
            if(pxTest.test(this.opts.riotValue)){
              min = 1
            }
          }
          this.min = min
        }

        changeRange(e) {
            var d = new Date();
            var currentTime = d.getTime();
            if(currentTime - this.previewRangeChange > 100){
              var remTest = /^-?[0-9.,]+(rem)$/
              var emTest = /^-?[0-9.,]+(em)$/
              var pxTest = /^-?[0-9]+(px)$/
              var numberTest = /^-?[0-9.,]+$/
              var newValue = e.target.value
              if(remTest.test(this.opts.riotValue)){
                newValue +='rem'
              }
              if(emTest.test(this.opts.riotValue)){
                newValue +='em'
              }
              if(pxTest.test(this.opts.riotValue)){
                newValue +='px'
              }
              if(numberTest.test(this.opts.riotValue)){
                newValue +='px'
              }
              this.opts.evchange({target:{
                    name: opts.name,
                    value: newValue
                }});

                var d = new Date();
                this.previewRangeChange = d.getTime();
            }
        }.bind(this)
        
        this.initValue()
        this.initStep()
        this.initMax()
        this.initMin()
        
        this.on('update', function(){
          this.initValue()
          this.initStep()
          this.initMax()
          this.initMin()
        })

        change(e) {
            this.opts.evchange(e);
        }.bind(this)
    </script>
</vd-range>