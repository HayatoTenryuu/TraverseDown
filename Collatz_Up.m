classdef Collatz_Up < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        StatusInactiveLabel            matlab.ui.control.Label
        QuiverCheckBox                 matlab.ui.control.CheckBox
        TDPlotCheckBox                 matlab.ui.control.CheckBox
        PlotCheckBox                   matlab.ui.control.CheckBox
        StopafterEditField             matlab.ui.control.NumericEditField
        StopafterEditFieldLabel        matlab.ui.control.Label
        StartingfromEditField          matlab.ui.control.NumericEditField
        StartingfromEditFieldLabel     matlab.ui.control.Label
        GoingbyEditField               matlab.ui.control.NumericEditField
        GoingbyEditFieldLabel          matlab.ui.control.Label
        LetsGoButton                   matlab.ui.control.Button
        TraverseDownDataEntryLabel     matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LetsGoButton
        function LetsGoButtonPushed(app, event)
            if (~isinteger(app.StartingfromEditField.Value))
                 app.StartingfromEditField.Value = round(app.StartingfromEditField.Value, 1);
            end
            
            if (~isinteger(app.GoingbyEditField.Value))
                app.StopafterEditField.Value = round(app.StopafterEditField.Value, 1);
            end

            if (~isinteger(app.StopafterEditField.Value))
                app.StopafterEditField.Value = round(app.StopafterEditField.Value, 1);
            end

            chainGraph(app.StartingfromEditField.Value, app.GoingbyEditField.Value, ...
                app.StopafterEditField.Value, app.QuiverCheckBox.Value, ...
                app.PlotCheckBox.Value, app.TDPlotCheckBox.Value, ...
                app.StatusInactiveLabel);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get screen size info for app positioning
            ScrSize = get(0, "ScreenSize");
            UISize = 480;
            UIPosX = (ScrSize(3)/2) - (UISize/2);
            UIPosY = (ScrSize(4)/2) - (UISize/2);

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [UIPosX UIPosY UISize UISize];
            app.UIFigure.Name = 'Collatz Down';
            app.UIFigure.WindowStyle = 'alwaysontop';

            % Create TraverseDownDataEntryLabel
            app.TraverseDownDataEntryLabel = uilabel(app.UIFigure);
            app.TraverseDownDataEntryLabel.FontSize = 28;
            app.TraverseDownDataEntryLabel.Position = [65 401 350 37];
            app.TraverseDownDataEntryLabel.Text = 'Traverse Down Data Entry:';

            % Create LetsGoButton
            app.LetsGoButton = uibutton(app.UIFigure, 'push');
            app.LetsGoButton.ButtonPushedFcn = createCallbackFcn(app, @LetsGoButtonPushed, true);
            app.LetsGoButton.FontSize = 16;
            app.LetsGoButton.Position = [145 94 171 48];
            app.LetsGoButton.Text = 'Let''s Go!';

            % Create StartingfromEditFieldLabel
            app.StartingfromEditFieldLabel = uilabel(app.UIFigure);
            app.StartingfromEditFieldLabel.HorizontalAlignment = 'center';
            app.StartingfromEditFieldLabel.FontSize = 14;
            app.StartingfromEditFieldLabel.Position = [69 343 100 22];
            app.StartingfromEditFieldLabel.Text = 'Starting from:';

            % Create StartingfromEditField
            app.StartingfromEditField = uieditfield(app.UIFigure, 'numeric');
            app.StartingfromEditField.ValueDisplayFormat = '%.0f';
            app.StartingfromEditField.HorizontalAlignment = 'center';
            app.StartingfromEditField.Position = [69 321 100 22];
            app.StartingfromEditField.Value = 1;

            % Create GoingbyEditFieldLabel
            app.GoingbyEditFieldLabel = uilabel(app.UIFigure);
            app.GoingbyEditFieldLabel.HorizontalAlignment = 'center';
            app.GoingbyEditFieldLabel.FontSize = 14;
            app.GoingbyEditFieldLabel.Position = [182 343 100 22];
            app.GoingbyEditFieldLabel.Text = 'Going up by:';

            % Create GoingbyEditField
            app.GoingbyEditField = uieditfield(app.UIFigure, 'numeric');
            app.GoingbyEditField.ValueDisplayFormat = '%.0f';
            app.GoingbyEditField.HorizontalAlignment = 'center';
            app.GoingbyEditField.Position = [182 321 100 22];
            app.GoingbyEditField.Value = 1;

            % Create StopafterEditFieldLabel
            app.StopafterEditFieldLabel = uilabel(app.UIFigure);
            app.StopafterEditFieldLabel.HorizontalAlignment = 'center';
            app.StopafterEditFieldLabel.FontSize = 14;
            app.StopafterEditFieldLabel.Position = [295 343 100 22];
            app.StopafterEditFieldLabel.Text = 'Stop after:';

            % Create StopafterEditField
            app.StopafterEditField = uieditfield(app.UIFigure, 'numeric');
            app.StopafterEditField.ValueDisplayFormat = '%.0f';
            app.StopafterEditField.HorizontalAlignment = 'center';
            app.StopafterEditField.Position = [295 321 100 22];
            app.StopafterEditField.Value = 10000;

            % Create PlotCheckBox
            app.PlotCheckBox = uicheckbox(app.UIFigure);
            app.PlotCheckBox.Text = 'Video of 2D graph';
            app.PlotCheckBox.Position = [178 219 150 22];

            % Create TDPlotCheckBox
            app.TDPlotCheckBox = uicheckbox(app.UIFigure);
            app.TDPlotCheckBox.Text = '3D graph';
            app.TDPlotCheckBox.Position = [178 192 96 22];

            % Create QuiverCheckBox
            app.QuiverCheckBox = uicheckbox(app.UIFigure);
            app.QuiverCheckBox.Text = 'Quiver graph';
            app.QuiverCheckBox.Position = [178 246 162 22];

            % Create StatusInactiveLabel
            app.StatusInactiveLabel = uilabel(app.UIFigure);
            app.StatusInactiveLabel.HorizontalAlignment = 'center';
            app.StatusInactiveLabel.FontSize = 14;
            app.StatusInactiveLabel.Position = [81 40 306 34];
            app.StatusInactiveLabel.Text = '< Status: Inactive >';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Collatz_Up

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
            delete(app)
        end
    end
end