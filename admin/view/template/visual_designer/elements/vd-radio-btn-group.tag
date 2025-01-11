<vd-radio-btn-group>
    <div class="btn-group vd-radio-btn-group" data-bs-toggle="buttons">
        <label each={value, key in opts.options} class="btn btn-success {parent.opts.riotValue == key?'active':''}" onClick={changeRadioGroup}>
            <input type="radio" name="{opts.name}" value="{key}" checked={parent.opts.riotValue == key} onChange={change}>{value}
        </label>
    </div>
    <script>
        change(e) {
            this.opts.evchange(e)
        }
        changeRadioGroup(e){
			const target = {target: {
                name: this.opts.name,
                value: e.target.childNodes[1] ? e.target.childNodes[1].value : e.target.value
            }};
            this.opts.evchange(target);
        }
    </script>
</vd-radio-btn-group>
