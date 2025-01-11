<vd-ckeditor>
	<textarea class="form-control" data-vd-toggle="ckeditor" name={opts.name}>{opts.riotValue}</textarea>
	<script>
	this.on('mount', function(){
		that = this;
		$('textarea[data-vd-toggle=\'ckeditor\']').ckeditor({
			language: that.opts.language
		});
		CKEDITOR.instances[that.opts.name].on('change', function() {
			that.opts.evchange(that.opts.name, e.CKEDITOR.instances[that.opts.name].getData());
		});
	});
	</script>
</vd-ckeditor>
