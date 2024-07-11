classdef LeastMeanSquare < handle
    %% Описание класса


    properties (Access = private)

        model                       % модель системы: mp, volterra, hammestein
        modelCoeffs                 % поле с вычисленными коэффициентами модели системы
        meanSquaredErrorValue       % значение mse 
        iterCount                   % кол-во итераций LMS
        systemCoeffs = [1, 0.2]     % коэффициенты анализируемой системы
        mu                          % скорость обучения LMS
        inputScaleCoeffs = 0.2      % коэффициент масщтабирования входного воздействия на систему

    end

    methods

        function this = LeastMeanSquare(modelIdx)
            % Конструктор класса

            if modelIdx == 1

                this.model = "memory polynomial";

                this.modelCoeffs = ones(2, 3);

            elseif modelIdx == 2

                this.model = "polynomial";

                this.modelCoeffs = ones(2, 1);

            else

                warning...

            end

        end

        function output = processInputThrughtSystem(input, this)

            output = this.systemCoeffs(1) .* input - this.systemCoeffs(1) .* input .* abs(input);

        end
        
        function input = generateInput(this)
            
            input = this.inputScaleCoeffs * (randn(1, this.iterCount) + 1i * randn(1, this.iterCount));

        end

        function findModelCoeffs(this)

        ......

        end

        function plotLearningGraph(this)
            
        ....

        end

    end
end

