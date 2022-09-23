clc
clear
close all
addpath quadriga_src/

% Параметры общие для всех методов
simulationParams.horizontalElementsCount = 8;
simulationParams.verticalElementsCount = 8;
simulationParams.nUsers = 8;
simulationParams.radAllocationMatrix = [];
simulationParams.seed = 1;

% Блок 1 входных параметров для расчета
simulationParams.beamformerMethod = 'MRT';

% Запуск конструктора класса 1
beamformerObjectMrt = Beamformer(simulationParams);

% Блок 2 входных параметров для расчета
simulationParams.beamformerMethod = 'ZF';

% Запуск конструктора класса 2
beamformerObjectZf = Beamformer(simulationParams);

% Создание массива объектов из разных блоков входных параметров
beamformerObjectList = [beamformerObjectMrt, beamformerObjectZf];

% Вывод зависимостей спектральной эффективности от ОСШ
beamformerObjectList.vuzailizeSpectralPerformance();
