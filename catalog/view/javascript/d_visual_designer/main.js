var vd = function () {
    
    riot.observable(this);

    this.initState = function(state){
        if(!_.isUndefined(this.state)){
            this.state.blocks = _.extend(this.state.blocks, state.blocks);
            this.state.config.field_name = _.extend(this.state.config.field_name, state.config.field_name);
            this.state.config.id = _.extend(this.state.config.id, state.config.id);
            this.state.config.route = _.extend(this.state.config.route, state.config.route);
            this.state.config.permission = _.extend(this.state.config.permission, state.config.permission);
            if(_.isUndefined(this.state.history)){
                this.state.history = state.history;
            } else {
                this.state.history = _.extend(this.state.history, state.history);
            }
            
        } else {
            this.state = state;
        }
    };

    this.initLocal = function(local){
        this.local = local;
    };

    this.initOptions = function(options){
        this.options = options;
    };

    this.updateState = function(data){
        this.state = _.extend(this.state, data);
        riot.update();
    };

    this.getOptions = function(path) {
        var keys = path.split('.');
        var option = this.options;
        
        for (key in keys) {
            if(typeof option[keys[key]] === undefined){
                option = path;
                break;
            } else {
                option = option[keys[key]];
            }
        }
        return option;
    };

    this.getLocal = function(path) {
        var keys = path.split('.');
        var text = this.local;
        
        for (key in keys) {
            if(typeof text[keys[key]] == undefined){
                text = path;
                break;
            } else {
                text = text[keys[key]];
            }
        }
        return text;
    };

    this.getBlocks = function (designer_id, parent_id) {
        var childBlocks = _.extend({}, this.state.blocks[designer_id]);

        childBlocks = _.pick(childBlocks, function(item) {
            return item.parent === parent_id;
        });

        var sortedBlocks = _.sortBy(childBlocks, function(value){
            return value.sort_order;
        });

        return sortedBlocks;
    };

    this.getState = function(){
        return this.state;
    };

    this.dispatch = function(action, state){
        this.trigger(action, state);
    };

    this.subscribe = function(action, callback){
        this.on(action, callback);
    };
};

var d_visual_designer = new vd();