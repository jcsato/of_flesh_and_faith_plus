"use strict";

var OathManagementScreen = function(_parent) {
    this.mSQHandle = null;

    this.mRoster = null;

    this.mContainer = null;
    this.mDialogContainer = null;
    this.mListContainer = null;
    this.mListScrollContainer = null;
    this.mNoOathCandidates = null;

    this.mDetailsPanel = {
        Container: null,
        CharacterImage: null,
        CharacterName: null,
        ScrollContainer: null,
        ScrollContainerList: null
    };

    this.mLeaveButton = null;

    this.mIsVisible = false;

    this.mSelectedEntry = null;
};

OathManagementScreen.prototype.isConnected = function() {
    return this.mSQHandle !== null;
};

OathManagementScreen.prototype.onConnection = function(_handle) {
    this.mSQHandle = _handle;
    this.register($('.root-screen'));
};

OathManagementScreen.prototype.onDisconnection = function() {
    this.mSQHandle = null;
    this.unregister();
};

OathManagementScreen.prototype.getModule = function(_name) {
    switch(_name) {
        default: return null;
    }
};

OathManagementScreen.prototype.getModules = function() {
    return [];
};

OathManagementScreen.prototype.createDIV = function(_parentDiv) {
    var self = this;

    // create: containers (init hidden!)
    this.mContainer = $('<div class="l-oath-management-dialog-container display-none opacity-none"/>');
    _parentDiv.append(this.mContainer);
    this.mDialogContainer = this.mContainer.createDialog('Oath Management', '', '', true, 'dialog-1024-768');

    // create tabs
    var tabButtonsContainer = $('<div class="l-tab-container"/>');
    this.mDialogContainer.findDialogTabContainer().append(tabButtonsContainer);

    // create content
    var content = this.mDialogContainer.findDialogContentContainer();

    // left column
    var column = $('<div class="column is-left"/>');
    content.append(column);
    var listContainerLayout = $('<div class="l-list-container"/>');
    column.append(listContainerLayout);
    this.mListContainer = listContainerLayout.createList(8.85);
    this.mListScrollContainer = this.mListContainer.findListScrollContainer();

    this.mNoOathCandidates = $('<div class="is-no-oaths-hint text-font-medium font-bottom-shadow font-color-description display-none">No one in your ranks can currently take on an Oath.</div>');
    listContainerLayout.append(this.mNoOathCandidates);

    // right column
    column = $('<div class="column is-right"/>');
    content.append(column);

    // details container
    var detailsFrame = $('<div class="l-details-frame"/>');
    column.append(detailsFrame);
    this.mDetailsPanel.Container = $('<div class="details-container display-none"/>');
    detailsFrame.append(this.mDetailsPanel.Container);

    // details: character container
    var detailsRow = $('<div class="row is-character-container"/>');
    this.mDetailsPanel.Container.append(detailsRow);
    var detailsColumn = $('<div class="column is-character-portrait-container"/>');
    detailsRow.append(detailsColumn);
    this.mDetailsPanel.CharacterImage = detailsColumn.createImage(null, function(_image) {
        var offsetX = 0;
        var offsetY = 0;

        if (self.mSelectedEntry !== null) {
            var data = self.mSelectedEntry.data('entry');
            if ('ImageOffsetX' in data && data['ImageOffsetX'] !== null &&
                'ImageOffsetY' in data && data['ImageOffsetY'] !== null) {
                offsetX = data['ImageOffsetX'];
                offsetY = data['ImageOffsetY'];
            }
        }

        _image.centerImageWithinParent(offsetX, offsetY, 1.0, false);
        _image.removeClass('opacity-none');
    }, null, 'opacity-none');

    var explanation = $('<div class="text-font-medium font-bottom-shadow font-color-description is-explanation">Have this character vow to fulfill one of the sacred Oaths, and in so doing be shaped by it.</div>');
    detailsRow.append(explanation);

    detailsColumn = $('<div class="column is-character-background-container"/>');
    detailsRow.append(detailsColumn);

    // details: background
    var backgroundRow = $('<div class="row is-top"/>');
    detailsColumn.append(backgroundRow);
    var backgroundRowBorder = $('<div class="row is-top border"/>');
    backgroundRow.append(backgroundRowBorder);

    this.mDetailsPanel.CharacterName = $('<div class="name title-font-normal font-bold font-color-brother-name"/>');
    backgroundRow.append(this.mDetailsPanel.CharacterName);
    backgroundRow = $('<div class="row is-bottom"/>');
    detailsColumn.append(backgroundRow);

    this.mDetailsPanel.ScrollContainer = backgroundRow.createList(4, 'is-oath-list', true);
    this.mDetailsPanel.ScrollContainerList = this.mDetailsPanel.ScrollContainer.findListScrollContainer();

    // create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"/>');
    this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

    // create: buttons
    var layout = $('<div class="l-leave-button"/>');
    footerButtonBar.append(layout);
    this.mLeaveButton = layout.createTextButton("Close", function() {
        self.notifyBackendCloseButtonPressed();
    }, '', 1);

    this.mIsVisible = false;
};

OathManagementScreen.prototype.destroyDIV = function() {

    this.mSelectedEntry = null;

    this.mDetailsPanel.CharacterName.empty();
    this.mDetailsPanel.CharacterName.remove();
    this.mDetailsPanel.CharacterName = null;

    this.mDetailsPanel.CharacterImage.empty();
    this.mDetailsPanel.CharacterImage.remove();
    this.mDetailsPanel.CharacterImage = null;

    this.mDetailsPanel.Container.empty();
    this.mDetailsPanel.Container.remove();
    this.mDetailsPanel.Container = null;

    this.mListScrollContainer.empty();
    this.mListScrollContainer = null;
    this.mListContainer.destroyList();
    this.mListContainer.remove();
    this.mListContainer = null;

    this.mLeaveButton.remove();
    this.mLeaveButton = null;

    this.mDialogContainer.empty();
    this.mDialogContainer.remove();
    this.mDialogContainer = null;

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};

OathManagementScreen.prototype.addListEntry = function(_data) {
    var result = $('<div class="l-row"/>');
    this.mListScrollContainer.append(result);

    var entry = $('<div class="ui-control list-entry"/>');
    result.append(entry);
    entry.data('entry', _data);
    entry.click(this, function(_event) {
        var self = _event.data;
        self.selectListEntry($(this));
    });

    // left column
    var column = $('<div class="column is-left"/>');
    entry.append(column);

    var imageOffsetX = ('ImageOffsetX' in _data ? _data['ImageOffsetX'] : 0);
    var imageOffsetY = ('ImageOffsetY' in _data ? _data['ImageOffsetY'] : 0);
    column.createImage(Path.PROCEDURAL + _data['ImagePath'], function(_image) {
        _image.centerImageWithinParent(imageOffsetX, imageOffsetY, 0.64, false);
        _image.removeClass('opacity-none');
    }, null, 'opacity-none');

    // right column
    column = $('<div class="column is-right"/>');
    entry.append(column);

    // top row
    var row = $('<div class="row is-top"/>');
    column.append(row);

    var image = $('<img/>');
    image.attr('src', Path.GFX + _data['BackgroundImagePath']);
    row.append(image);

    // bind tooltip
    image.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterBackgrounds.Generic, elementOwner: TooltipIdentifier.ElementOwner.HireScreen, entityId: _data.ID });

    var name = $('<div class="name title-font-normal font-bold font-color-brother-name">' + _data.Name + '</div>');
    row.append(name);

    // bind tooltip
    var levelContainer = $('<div class="l-level-container"/>');
    row.append(levelContainer);
    image = $('<img/>');
    image.attr('src', Path.GFX + Asset.ICON_LEVEL);
    levelContainer.append(image);
    var level = $('<div class="level text-font-normal font-bold font-color-subtitle">' + _data.Level + '</div>');
    levelContainer.append(level);

    // bottom row
    row = $('<div class="row is-bottom"/>');
    entry.data('bottom', row);
    column.append(row);

    for (var i = 0; i < _data.Effects.length; ++i) {
        var icon = $('<img src="' + Path.GFX + _data.Effects[i].icon + '"/>');
        icon.bindTooltip({ contentType: 'status-effect', entityId: _data.ID, statusEffectId: _data.Effects[i].id });
        row.append(icon);
    }
};


OathManagementScreen.prototype.updateSelectedListEntry = function(_data) {
    if (this.mSelectedEntry == null)
        return;

    this.mSelectedEntry.data('entry', _data);

    // portrait
    var result = this.mSelectedEntry.find('img:first');
    if (result.length > 0) {
        result.attr('src', Path.PROCEDURAL + _data['ImagePath']);
    }

    // effects
    var row = this.mSelectedEntry.data('bottom');
    row.empty();

    for (var i = 0; i < _data.Effects.length; ++i) {
        var icon = $('<img src="' + Path.GFX + _data.Effects[i].icon + '"/>');
        icon.bindTooltip({ contentType: 'status-effect', entityId: _data.ID, statusEffectId: _data.Effects[i].id });
        row.append(icon);
    }
};

OathManagementScreen.prototype.selectListEntry = function(_element, _scrollToEntry) {
    if (_element !== null && _element.length > 0) {
        this.mListContainer.deselectListEntries();
        _element.addClass('is-selected');

        // give the renderer some extra time
        if (_scrollToEntry !== undefined && _scrollToEntry === true)
        {
            this.mListContainer.scrollListToElement(_element);
        }

        this.mSelectedEntry = _element;
        this.updateDetailsPanel(this.mSelectedEntry);
    } else {
        this.mSelectedEntry = null;
        this.updateDetailsPanel(this.mSelectedEntry);
    }
};

OathManagementScreen.prototype.removeRosterEntry = function(_entry) {
    if (_entry !== null) {
        var data = _entry.data('entry');
        if ('ID' in data && data['ID'] !== null && _data.item['ID'] === data['ID']) {
            entry = _entry.parent(); // get the 'l-row' container
            var prevEntry = _entry.prev();
            _entry.remove();

            if (prevEntry.length > 0) {
                this.selectListEntry(prevEntry.find('.list-entry:first'), false/*true*/);
            } else {
                this.selectListEntry(this.mListContainer.findListEntryByIndex(0), true);
            }

            this.mRoster.splice(_data.index, 1);
        } else {
            console.error('ERROR: Failed to update oath roster. Invalid entry data.');
        }
    }
};

OathManagementScreen.prototype.updateDetailsPanel = function(_element) {
    if (_element !== null && _element.length > 0) {
        var data = _element.data('entry');

        this.mDetailsPanel.CharacterImage.attr('src', Path.PROCEDURAL + data.ImagePath);     
        this.mDetailsPanel.CharacterImage.centerImageWithinParent(0, 0, 1.0); 

        this.mDetailsPanel.CharacterName.html(data['Name']);

        this.mDetailsPanel.ScrollContainerList.empty();

        if (data.OathsAvailable.length != 0) {
            for (var i = 0; i < data.OathsAvailable.length; ++i) {
                this.createOathAcceptanceDIV(i, this.mDetailsPanel.ScrollContainerList, data.ID, data.OathsAvailable[i]);
            }
        } else if (data.OathsToComplete.length != 0) {
            for (var i = 0; i < data.OathsToComplete.length; ++i) {
                this.createOathCompletionDIV(i, this.mDetailsPanel.ScrollContainerList, data.ID, data.OathsToComplete[i]);
            }
        } else {
            var row = $('<div class="is-oath-row display-block text-font-medium font-bottom-shadow font-color-description display-none">No Oaths can be completed nor new ones undertaken at this time.</div>');
            this.mDetailsPanel.ScrollContainerList.append(row);
        }

        this.mDetailsPanel.Container.removeClass('display-none').addClass('display-block');
    } else {
        this.mDetailsPanel.Container.removeClass('display-block').addClass('display-none');
    }
};

OathManagementScreen.prototype.createOathAcceptanceDIV = function(_i, _parentDiv, _entityID, _data) {
    var self = this;

    var row = $('<div class="is-oath-row display-block"/>');
    row.css({ 'top': ((7.5*_i) + 'rem') });
    _parentDiv.append(row);

    var icon = $('<img class="is-icon"/>');
    icon.attr('src', Path.GFX + _data.icon);
    icon.bindTooltip({ contentType: 'oath-effect', oathId: _data.tooltipID });
    row.append(icon);

    var name = $('<div class="is-name text-font-normal font-bottom-shadow font-color-description">' + _data.name + '</div>');
    row.append(name);

    var layout = $('<div class="is-button"/>');
    row.append(layout);

    var undertake = $('<div class="is-confirm"><div class="is-confirm-ffs">Undertake</div></div>');
    layout.createCustomButton(undertake, function() {
        self.notifyBackendOathAccepted(_data.ID, _entityID, function(_result) {
            self.updateSelectedListEntry(_result.Entity);
            self.updateDetailsPanel(self.mSelectedEntry);
        });
        undertake.unbindTooltip();
    }, '', 1);

    undertake.bindTooltip({ contentType: 'oath-effect', oathId: _data.completedTooltipID })
};

OathManagementScreen.prototype.createOathCompletionDIV = function(_i, _parentDiv, _entityID, _data) {
    var self = this;

    var row = $('<div class="is-oath-row display-block"/>');
    row.css({ 'top': ((7.5*_i) + 'rem') });
    _parentDiv.append(row);

    var icon = $('<img class="is-icon"/>');
    icon.attr('src', Path.GFX + _data.icon);
    icon.bindTooltip({ contentType: 'oath-effect', oathId: _data.tooltipID, entityId: _data.entityId });
    row.append(icon);

    var name = $('<div class="is-name text-font-normal font-bottom-shadow font-color-description">' + _data.name + '</div>');
    row.append(name);

    var layout = $('<div class="is-button"/>');
    row.append(layout);

    var complete = $('<div class="is-confirm"><div class="is-confirm-ffs">Complete</div></div>');
    layout.createCustomButton(complete, function() {
        self.notifyBackendOathCompleted(_data.ID, _entityID, function(_result) {
            self.updateSelectedListEntry(_result.Entity);
            self.updateDetailsPanel(self.mSelectedEntry);
        });
        complete.unbindTooltip();
    }, '', 1);

    complete.bindTooltip({ contentType: 'oath-effect', oathId: _data.completedTooltipID })
};

OathManagementScreen.prototype.bindTooltips = function() {
//  this.mColumnAmbition.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldScreen.CompanyDetails.ColumnAmbition });
//  this.mColumnCompleted.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldScreen.CompanyDetails.ColumnCompleted });
};

OathManagementScreen.prototype.unbindTooltips = function() {
//  this.mColumnAmbition.unbindTooltip();
//  this.mColumnCompleted.unbindTooltip();
};

OathManagementScreen.prototype.create = function(_parentDiv) {
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

OathManagementScreen.prototype.destroy = function() {
    this.unbindTooltips();
    this.destroyDIV();
};

OathManagementScreen.prototype.register = function(_parentDiv) {
    console.log('OathManagementScreen::REGISTER');

    if (this.mContainer !== null) {
        console.error('ERROR: Failed to register Oath Management Screen. Reason: Already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object') {
        this.create(_parentDiv);
    }
};

OathManagementScreen.prototype.unregister = function() {
    console.log('OathManagementScreen::UNREGISTER');

    if (this.mContainer === null) {
        console.error('ERROR: Failed to unregister Oath Management Screen. Reason: Not initialized.');
        return;
    }

    this.destroy();
};

OathManagementScreen.prototype.isRegistered = function() {
    if (this.mContainer !== null) {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};

OathManagementScreen.prototype.show = function(_data) {
    this.loadFromData(_data);

    var self = this;

    var offset = -(this.mContainer.parent().width() + this.mContainer.width());
    this.mContainer.css({ 'left': offset });
    this.mContainer.velocity("finish", true).velocity({ opacity: 1, left: '0', right: '0' }, {
        duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function() {
            $(this).removeClass('display-none').addClass('display-block');
            self.notifyBackendOnAnimating();
        },
        complete: function() {
            self.mIsVisible = true;
            self.notifyBackendOnShown();
        }
    });
};

OathManagementScreen.prototype.hide = function(_withSlideAnimation) {
    var self = this;

    var withAnimation = true;//(_withSlideAnimation !== undefined && _withSlideAnimation !== null) ? _withSlideAnimation : true;
    if (withAnimation === true) {
        var offset = -(self.mContainer.parent().width() + self.mContainer.width());
        self.mContainer.velocity("finish", true).velocity({ opacity: 0, left: offset },
        {
            duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function() {
                $(this).removeClass('is-center');
                self.notifyBackendOnAnimating();
            },
            complete: function() {
                self.mIsVisible = false;
                self.mListScrollContainer.empty();
                $(this).removeClass('display-block').addClass('display-none');
                self.notifyBackendOnHidden();
            }
        });
    } else {
        self.mContainer.velocity("finish", true).velocity({ opacity: 0 }, {
            duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function()
            {
                $(this).removeClass('is-center');
                self.notifyBackendOnAnimating();
            },
            complete: function()
            {
                self.mIsVisible = false;
                self.mListScrollContainer.empty();
                $(this).removeClass('display-block').addClass('display-none');
                self.notifyBackendOnHidden();
            }
        });
    }
};

OathManagementScreen.prototype.isVisible = function() {
    return this.mIsVisible;
};


OathManagementScreen.prototype.loadFromData = function(_data) {
    if (_data === undefined || _data === null) {
        return;
    }

    if ('Title' in _data && _data.Title !== null) {
        this.mDialogContainer.findDialogTitle().html(_data.Title);
    }

    if ('SubTitle' in _data && _data.SubTitle !== null) {
        this.mDialogContainer.findDialogSubTitle().html(_data.SubTitle);
    }

    this.mRoster = _data.Roster;

    this.mListScrollContainer.empty();

    if (_data.Roster.length != 0) {
        this.mNoOathCandidates.addClass('display-none');

        for (var i = 0; i < _data.Roster.length; ++i) {
            var entry = _data.Roster[i];
            this.addListEntry(entry);
        }
    } else {
        this.mNoOathCandidates.removeClass('display-none');
    }

    this.selectListEntry(this.mListContainer.findListEntryByIndex(0), true);
};

OathManagementScreen.prototype.notifyBackendOnConnected = function() {
    if (this.mSQHandle !== null) {
        SQ.call(this.mSQHandle, 'onScreenConnected');
    }
};

OathManagementScreen.prototype.notifyBackendOnDisconnected = function() {
    if (this.mSQHandle !== null) {
        SQ.call(this.mSQHandle, 'onScreenDisconnected');
    }
};

OathManagementScreen.prototype.notifyBackendOnShown = function() {
    if (this.mSQHandle !== null) {
        SQ.call(this.mSQHandle, 'onScreenShown');
    }
};

OathManagementScreen.prototype.notifyBackendOnHidden = function() {
    if (this.mSQHandle !== null) {
        SQ.call(this.mSQHandle, 'onScreenHidden');
    }
};

OathManagementScreen.prototype.notifyBackendOnAnimating = function() {
    if (this.mSQHandle !== null) {
        SQ.call(this.mSQHandle, 'onScreenAnimating');
    }
};

OathManagementScreen.prototype.notifyBackendCloseButtonPressed = function(_buttonID) {
    if (this.mSQHandle !== null) {
        SQ.call(this.mSQHandle, 'onClose', _buttonID);
    }
};

OathManagementScreen.prototype.notifyBackendOathAccepted = function(_entityID, _oathID, _callback) {
    SQ.call(this.mSQHandle, 'onAccepted', [ _entityID, _oathID ], _callback);
};

OathManagementScreen.prototype.notifyBackendOathCompleted = function(_entityID, _oathID, _callback) {
    SQ.call(this.mSQHandle, 'onCompleted', [ _entityID, _oathID ], _callback);
};
