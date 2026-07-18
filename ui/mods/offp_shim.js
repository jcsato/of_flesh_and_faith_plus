"use strict";

// screens.js
registerScreen("OathManagementScreen", new OathManagementScreen());
registerScreen("AssassinRespecScreen", new AssassinRespecScreen());

var originalTooltipModuleNotifyBackendQueryTooltipData = TooltipModule.prototype.notifyBackendQueryTooltipData;
TooltipModule.prototype.notifyBackendQueryTooltipData = function (_data, _callback) {
    originalTooltipModuleNotifyBackendQueryTooltipData.call(this, _data, _callback);

    if ('contentType' in _data) {
        if (_data.contentType === 'oath-effect') {
            SQ.call(this.mSQHandle, 'onQueryOathTooltipData', [_data.oathId, ('entityId' in _data ? _data.entityId : null)], _callback);
        }
        if (_data.contentType === 'respec-effect') {
            SQ.call(this.mSQHandle, 'onQuerySpecialtyTooltipData', [_data.specialtyId, ('entityId' in _data ? _data.entityId : null)], _callback);
        }
    }
}

var originalTooltipModuleBuildFromData = TooltipModule.prototype.buildFromData;
TooltipModule.prototype.buildFromData = function(_data, _shouldBeUpdated, _contentType) {
    originalTooltipModuleBuildFromData.call(this, _data, _shouldBeUpdated, _contentType);

    if (_contentType === 'oath-effect') {
        this.mContainer.addClass('is-full-width is-status-effect-content');
    }

    if (_contentType === 'respec-effect') {
        this.mContainer.addClass('is-full-width is-status-effect-content');
    }
}
