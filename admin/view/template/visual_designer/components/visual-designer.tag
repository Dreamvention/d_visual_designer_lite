<visual-designer>
    <div class="vd mode_switch" if={!store.getState().config.independent[opts.id]}>
        <a id="button_classic" class="btn btn-secondary" hide={store.getState().config.mode[opts.id] == 'classic'} onClick={modeClassic}><formatted-message path='designer.text_classic_mode'/></a>
        <a id="button_vd" class="btn btn-secondary" hide={!store.getState().config.mode[opts.id] || store.getState().config.mode[opts.id] == 'designer'} onClick={modeDesigner}><formatted-message path='designer.text_backend_editor'/></a>
    </div>
    <div class="content vd" hide={store.getState().config.mode[opts.id] == 'classic'}>
        <div class="row" style="justify-content: space-between" id="d_visual_designer_nav">
            <div style="width: auto" class="float-start">
                <a class="btn btn-add btn-default" onClick={addBlock}></a>
                <a class="btn btn-template btn-default" onClick={addTemplate}></a>
                <a class="btn btn-save-template btn-default" onClick={saveTemplate}></a>
            </div>
            <div style="width: auto" class="float-end">
                <a class="btn btn-default vd-btn-text"
                    onClick={frontend}
                    if={store.getState().config.route_info.frontend_status && store.getState().config.id}
                >
                    <formatted-message path='designer.text_frontend_editor'/>
                </a>
                <a class="btn btn-code-view btn-default" onClick={codeView}></a>
                <a class="btn btn-full-screen btn-default" onclick={fullscreen}></a>
            </div>
        </div>
        <div class="vd-designer" id="sortable"><virtual data-is="wrapper-blocks" selector={"#"+top.opts.id+" #sortable"}/></div>
        <div class="vd-welcome" if={emptyDesigner}>
            <div class="vd-welcome-header"><formatted-message path='designer.text_welcome_header'/></div>
            <div class="vd-button-group">
                <a class="vd-button vd-add-block" title="Add Element" onClick={addBlock}><formatted-message path='designer.text_add_block'/></a>
                <a class="vd-button vd-add-text-block" title="Add text block" onClick={addTextBlock}>
                    <i class="fal fa-pen-square"></i>
                    <formatted-message path='designer.text_add_text_block'/>
                </a>
                <a id="vd-add-template" class="vd-button vd-add-template" onClick={addTemplate}><formatted-message path='designer.text_add_template'/></a>
            </div>
            <div class="vc_welcome-visible-ne">
                <a id="vc_not-empty-add-element" class="vc_add-element-not-empty-button" title="Add Element" data-vc-element="add-element-action" onClick={addBlock}></a>
            </div>
        </div>
    </div>
    <vd-popup-new-block/>
    <vd-popup-setting-block/>
    <vd-popup-layout-block/>
    <vd-popup-save-template/>
    <vd-popup-load-template/>
    <vd-popup-image-manager/>
    <vd-popup-codeview/>
    <textarea style="display:none;" name="{fieldName}">{content}</textarea>
    <script>
        this.mixin({store:d_visual_designer})
        this.top = this.parent ? this.parent.top : this
        this.emptyDesigner = _.isEmpty(this.store.getState().blocks[this.top.opts.id])
        this.loading = true
        this.initName = function(){
            if(!this.store.getState().config.independent[this.top.opts.id]) {
                this.fieldName = $(this.root).closest('.row.mb-3').find('.d_visual_designer').attr('name')
            } else {
                this.fieldName = $(this.root).closest('.row.mb-3').find('.d_visual_designer_backend').data('name')
            }

            this.fieldName = 'vd_content[' + escape(this.fieldName) + ']'
        }
        this.initName()
        addBlock() {
            this.store.dispatch('popup/addBlock', {level: 0, parent_id: '', designer_id: this.top.opts.id});
        }
        addTemplate() {
            this.store.dispatch('template/list', {designer_id: this.top.opts.id});
        }
        saveTemplate() {
            this.store.dispatch('template/save/popup', {designer_id: this.top.opts.id});
        }
        codeView() {
            this.store.dispatch('content/codeview', {designer_id: this.top.opts.id});
        }
        addTextBlock() {
            this.store.dispatch('block/new', {type: 'text', designer_id:this.top.opts.id, target: '', level: 0})
        }
        this.store.subscribe('block/setting/update/end', function(data){
            if(this.top.opts.id == data.designer_id) {
                this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
                $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
            }
        }.bind(this))
        this.store.subscribe('template/load/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        this.store.subscribe('block/clone/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        this.store.subscribe('block/move/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        this.store.subscribe('block/remove/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        this.store.subscribe('designer/update/blocks/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        this.store.subscribe('block/create/success', function(data){
            if(this.top.opts.id == data.designer_id) {
                this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
                $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
            }
        }.bind(this))
        this.store.subscribe('block/layout/update/success', function(data){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
           $('textarea[name=\''+this.fieldName+'\']', this.root).html(this.content).val(this.content)
        }.bind(this))
        fullscreen() {
            if ($('.vd.content', this.root).hasClass('fullscreen')) {
                $('.vd.content', this.root).removeClass('fullscreen');
                $(this.root).find('#d_visual_designer_nav').find('.btn-full-screen').removeClass('active');
                $('body').removeAttr('style');
            } else {
                $('.vd.content', this.root).addClass('fullscreen');
                $(this.root).find('#d_visual_designer_nav').find('.btn-full-screen').addClass('active');
                $('body').attr('style', 'overflow:hidden');
            }
        }
        modeClassic(){
            this.store.dispatch('designer/update/content', {designer_id: this.top.opts.id})
            this.store.dispatch('content/mode/update', {designer_id: this.top.opts.id, mode: 'classic'});
        }
        modeDesigner(){
            this.store.dispatch('content/mode/update', {designer_id: this.top.opts.id, mode: 'designer'});
        }

        frontend() {

            if(!this.store.getState().config.independent[this.top.opts.id]) {
                var fieldName = $(this.root).closest('.row.mb-3').find('.d_visual_designer').attr('name')
            } else {
                var fieldName = $(this.root).closest('.row.mb-3').find('.d_visual_designer_backend').data('name')
            }

            this.store.dispatch('designer/frontend', {designer_id: this.top.opts.id, fieldName: fieldName, form: $(this.root).closest('form')})
        }
        this.on('update', function(){
            this.emptyDesigner = _.isEmpty(this.store.getState().blocks[this.top.opts.id])
        })

        this.initMode = function(){
            var mode = this.store.getState().config.mode[this.opts.id]
            if(mode == 'designer') {
                $(this.root).closest('.row.mb-3').find('.note-editor').hide()
                $(this.root).closest('.row.mb-3').find('.cke').hide()
            }
            if(mode == 'classic') {
                $(this.root).closest('.row.mb-3').find('.note-editor').show()
                $(this.root).closest('.row.mb-3').find('.cke').show()
            }
        }

        this.store.subscribe('content/update/text', function(data) {
            var element =  $(this.root).closest('.row.mb-3').find('.d_visual_designer')

            $(element).get(0).innerText = data.text;

            if ($(element).hasClass('summernote')) {
                $(element).summernote('code', data.text)
            }
        }.bind(this))

        this.store.subscribe('content/mode/update/success', function(){
            this.initMode();
        }.bind(this))

        this.on('mount', function(){
            this.content = JSON.stringify(this.store.getState().blocks[this.top.opts.id])
            new vd_sortable({designer_id: this.top.opts.id})
        })

        $('body').on('designerSave', function(){
            this.store.dispatch('content/save', {designer_id: this.top.opts.id});
        }.bind(this));
    </script>
</visual-designer>
