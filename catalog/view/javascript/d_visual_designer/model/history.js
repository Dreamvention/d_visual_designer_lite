(function(){
    this.subscribe('history/backup', function(data) {
        this.updateHistory(data.designer_id, data.block_id, data.fast);
    });
    this.subscribe('history/undo', function(data) {
        this.undoHistory(data.designer_id, data.block_id, data.fast);
    });
    this.subscribe('history/return', function(data) {
        this.returnHistory(data.designer_id, data.block_id);
    });
    this.updateHistory = function(designer_id, block_id, fast) {
        var block_info = this.getState().blocks[designer_id][block_id];
        if(_.isUndefined(this.state.history[designer_id][block_id])){
            this.state.history[designer_id][block_id] = [];
        }
        _.mapObject(this.state.history[designer_id][block_id], function(value) {
            value.active = false;
            return value;
        })
        this.state.history[designer_id][block_id].push({setting: JSON.parse(JSON.stringify(block_info.setting)), active: true, fast: fast, sort_order: _.size(this.state.history[designer_id][block_id])});
    };
    this.getHistory = function(designer_id, block_id) {
        if(_.isUndefined(this.state.history[designer_id][block_id])){
            return [];
        } else {
            return this.state.history[designer_id][block_id];
        }
    };
    this.undoHistory = function(designer_id, block_id, fast) {
        var history = this.getHistory(designer_id, block_id);
        var currentHistory = _.where(history, {active: true});
        history = _.filter(history, function(value){ return value.fast == fast });
        var minHistory = _.min(history, function(value){ return value.sort_order});
        if(!_.isEmpty(currentHistory) && currentHistory[0].sort_order > minHistory.sort_order ) {
            var lastIndex = _.findLastIndex(history, function(value){ return value.sort_order < currentHistory[0].sort_order});
            var nextHistory = history[lastIndex];
            var blocks = this.getState().blocks;

            blocks[designer_id][block_id].setting = nextHistory.setting;

            this.state.history[designer_id][block_id] = _.map(this.state.history[designer_id][block_id], function(value) {
                if(value.sort_order == nextHistory.sort_order) {
                    value.active = true;
                } else {
                    value.active = false;
                }
                return value;
            });

            this.updateState({blocks: blocks});
        }
    };
    this.returnHistory = function(designer_id, block_id) {
        var history = this.getHistory(designer_id, block_id);
        var currentHistory = _.where(history, {active: true});
        var maxHistory = _.max(history, function(value){ return value.sort_order; });
        if(!_.isEmpty(currentHistory) && currentHistory[0].sort_order < maxHistory.sort_order ) {
            var lastIndex = _.findIndex(history, function(value){ return (value.sort_order > currentHistory[0].sort_order); });
            var nextHistory = history[lastIndex];
            var blocks = this.getState().blocks;

            blocks[designer_id][block_id].setting = nextHistory.setting;

            this.state.history[designer_id][block_id] = _.map(this.state.history[designer_id][block_id], function(value) {
                if(value.sort_order == nextHistory.sort_order) {
                    value.active = true;
                } else {
                    value.active = false;
                }
                return value;
            })

            this.updateState({blocks: blocks});
        }
    };
}.bind(d_visual_designer))();