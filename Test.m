classdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        GridLayout            matlab.ui.container.GridLayout
        Theta3EditField       matlab.ui.control.NumericEditField
        Theta3EditFieldLabel  matlab.ui.control.Label
        ZEditField            matlab.ui.control.NumericEditField
        ZEditFieldLabel       matlab.ui.control.Label
        Theta2EditField       matlab.ui.control.NumericEditField
        Theta2EditFieldLabel  matlab.ui.control.Label
        YEditField            matlab.ui.control.NumericEditField
        YEditFieldLabel       matlab.ui.control.Label
        Theta1EditField       matlab.ui.control.NumericEditField
        Theta1EditFieldLabel  matlab.ui.control.Label
        XEditField            matlab.ui.control.NumericEditField
        XEditFieldLabel       matlab.ui.control.Label
        BackwardButton        matlab.ui.control.Button
        ForwardButton         matlab.ui.control.Button
        UIAxes                matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ForwardButton
        function ForwardButtonPushed(app, event)
            Theta1 = (app.Theta1EditField.Value)*pi/ 180;
            Theta2 = (app.Theta2EditField.Value)*pi/ 180;
            Theta3 = (app.Theta3EditField.Value)*pi/ 180;
            L_1 = 20 ;
            L_2 = 50;
            L_3 = 40 ;
            L(1) = Link([0  L_1   0    pi/2]);
            L(2) = Link([0  0    L_2     0 ]);
            L(3) = Link([0  0    L_3      0]);
            Robot = SerialLink(L);
            Robot.name = 'RRR_Robot';
            Robot.plot([Theta1   Theta2  Theta3]);
            T = Robot.fkine([Theta1   Theta2  Theta3]);
            app.XEditField.Value = floor(T(1,4));
            app.YEditField.Value = floor(T(2,4));
            app.ZEditField.Value = floor(T(3,4));
        end

        % Button pushed function: BackwardButton
        function BackwardButtonPushed(app, event)
            PX = (app.XEditField.Value);
            PY = (app.YEditField.Value);
            PZ = (app.ZEditField.Value);
            L_1 = 20;
            L_2 = 50;
            L_3 = 40;
            L(1) = Link([0  L_1   0    pi/2]);
            L(2) = Link([0  0    L_2     0 ]);
            L(3) = Link([0  0    L_3      0]);
            Robot = SerialLink(L);
            Robot.name = 'RRR_Robot';
            T = [1 0 0 PX
                 0 1 0 PY
                 0 0 1 PZ
                 0 0 0 1];
            j = Robot.ikine(T, [0 0 0], [1 1 1 0 0 0]) * 180/pi;
            app.Theta1EditField.Value = floor(j(1));
            app.Theta2EditField.Value = floor(j(2));
            app.Theta3EditField.Value = floor(j(3));
            Robot.plot(j*pi/180);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x', 25, 100, '2.04x', 46, 100, '9x'};
            app.GridLayout.RowHeight = {'1x', 22, '1.47x', 22, '2.2x', 22, '2x', 22, '12.8x'};

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout);
            title(app.UIAxes, 'Figure')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Layout.Row = [8 9];
            app.UIAxes.Layout.Column = [2 7];

            % Create ForwardButton
            app.ForwardButton = uibutton(app.GridLayout, 'push');
            app.ForwardButton.ButtonPushedFcn = createCallbackFcn(app, @ForwardButtonPushed, true);
            app.ForwardButton.Layout.Row = 7;
            app.ForwardButton.Layout.Column = 3;
            app.ForwardButton.Text = 'Forward';

            % Create BackwardButton
            app.BackwardButton = uibutton(app.GridLayout, 'push');
            app.BackwardButton.ButtonPushedFcn = createCallbackFcn(app, @BackwardButtonPushed, true);
            app.BackwardButton.Layout.Row = 7;
            app.BackwardButton.Layout.Column = 6;
            app.BackwardButton.Text = 'Backward';

            % Create XEditFieldLabel
            app.XEditFieldLabel = uilabel(app.GridLayout);
            app.XEditFieldLabel.HorizontalAlignment = 'right';
            app.XEditFieldLabel.Layout.Row = 2;
            app.XEditFieldLabel.Layout.Column = 2;
            app.XEditFieldLabel.Text = 'X';

            % Create XEditField
            app.XEditField = uieditfield(app.GridLayout, 'numeric');
            app.XEditField.Layout.Row = 2;
            app.XEditField.Layout.Column = 3;

            % Create Theta1EditFieldLabel
            app.Theta1EditFieldLabel = uilabel(app.GridLayout);
            app.Theta1EditFieldLabel.HorizontalAlignment = 'right';
            app.Theta1EditFieldLabel.Layout.Row = 2;
            app.Theta1EditFieldLabel.Layout.Column = 5;
            app.Theta1EditFieldLabel.Text = 'Theta 1';

            % Create Theta1EditField
            app.Theta1EditField = uieditfield(app.GridLayout, 'numeric');
            app.Theta1EditField.Layout.Row = 2;
            app.Theta1EditField.Layout.Column = 6;

            % Create YEditFieldLabel
            app.YEditFieldLabel = uilabel(app.GridLayout);
            app.YEditFieldLabel.HorizontalAlignment = 'right';
            app.YEditFieldLabel.Layout.Row = 4;
            app.YEditFieldLabel.Layout.Column = 2;
            app.YEditFieldLabel.Text = 'Y';

            % Create YEditField
            app.YEditField = uieditfield(app.GridLayout, 'numeric');
            app.YEditField.Layout.Row = 4;
            app.YEditField.Layout.Column = 3;

            % Create Theta2EditFieldLabel
            app.Theta2EditFieldLabel = uilabel(app.GridLayout);
            app.Theta2EditFieldLabel.HorizontalAlignment = 'right';
            app.Theta2EditFieldLabel.Layout.Row = 4;
            app.Theta2EditFieldLabel.Layout.Column = 5;
            app.Theta2EditFieldLabel.Text = 'Theta 2';

            % Create Theta2EditField
            app.Theta2EditField = uieditfield(app.GridLayout, 'numeric');
            app.Theta2EditField.Layout.Row = 4;
            app.Theta2EditField.Layout.Column = 6;

            % Create ZEditFieldLabel
            app.ZEditFieldLabel = uilabel(app.GridLayout);
            app.ZEditFieldLabel.HorizontalAlignment = 'right';
            app.ZEditFieldLabel.Layout.Row = 6;
            app.ZEditFieldLabel.Layout.Column = 2;
            app.ZEditFieldLabel.Text = 'Z';

            % Create ZEditField
            app.ZEditField = uieditfield(app.GridLayout, 'numeric');
            app.ZEditField.Layout.Row = 6;
            app.ZEditField.Layout.Column = 3;

            % Create Theta3EditFieldLabel
            app.Theta3EditFieldLabel = uilabel(app.GridLayout);
            app.Theta3EditFieldLabel.HorizontalAlignment = 'right';
            app.Theta3EditFieldLabel.Layout.Row = 6;
            app.Theta3EditFieldLabel.Layout.Column = 5;
            app.Theta3EditFieldLabel.Text = 'Theta 3';

            % Create Theta3EditField
            app.Theta3EditField = uieditfield(app.GridLayout, 'numeric');
            app.Theta3EditField.Layout.Row = 6;
            app.Theta3EditField.Layout.Column = 6;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1

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
        end
    end
end