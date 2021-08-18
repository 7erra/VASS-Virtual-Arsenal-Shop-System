class ctrlDefault;
class ctrlButton;
class ctrlListNBox;
class ctrlStatic;
class ctrlToolbox;
class ctrlEdit;
class ctrlCheckboxBaseline;
class ctrlCombo;
class ctrlControlsGroup;
class ctrlStructuredText;
class ctrlCheckboxes;
class ctrlStaticBackgroundDisable;
class ctrlStaticBackgroundDisableTiles;
class ctrlStaticBackground;
class ctrlStaticTitle;
class ctrlButtonCancel;
class ctrlStaticFooter;
class ctrlButtonOK;
class ctrlControlsGroupNoScrollbars;
class ctrlCheckbox;
class ctrlControlsTable: ctrlControlsGroup
{
	idc = -1;
	type = CT_CONTROLS_TABLE;
	style = SL_TEXTURES;

	lineSpacing = 0;
	rowHeight = 5 * GRID_H;
	headerHeight = 5 * GRID_H;
	firstIDC = 100;
	lastIDC = 999;
	// Colours which are used for animation (i.e. change of colour) of the selected line.
	selectedRowColorFrom[]  = {0.7, 0.85, 1, 0.25};
	selectedRowColorTo[]	= {0.7, 0.85, 1, 0.5};
	// Length of the animation cycle in seconds.
	selectedRowAnimLength = 1.2;
	// Template for selectable rows
	class RowTemplate
	{
	};
	class HeaderTemplate
	{
	};
};
