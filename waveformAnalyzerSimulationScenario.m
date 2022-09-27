% Скрипт для запуска waveformAnalyxer

close all
clear all
clc

% Директория с файлами
sourceDirectory = "waveform";

% Название файла с описанием сигнала
waveformInfoName = "waveformInfo.mat";

% Название файла с отсчетами сигнала
waveformSourceName = "waveformSource.mat";

% Загрузить описание сигнала
f = load(sourceDirectory+string(filesep)+waveformInfoName);
waveformInfo = f.info;

% Загрузить отсчеты сигнала
f = load(sourceDirectory+string(filesep)+waveformSourceName);
waveformSamples = f.txWaveform;

% Создать объект класса analyzer
analyzer = WaveformAnalyzer(waveformSamples, waveformInfo);

% Рассчитать параметры сигнала
analyzer.calcWaveformParameters();

% Вывести параметры сигнала
fprintf("Средняя мощность сигнала: %f\n", analyzer.waveformMeanPower);
fprintf("Полоса сигнала: %f Hz\n", analyzer.signalBandwidth);
fprintf("Тип модуляции сигнала: %s\n", analyzer.modulationType);
fprintf("Длительность сигнала: %f seconds\n", analyzer.waveformDuration);

% Построить спектральную плотность мощности
analyzer.plotPowerSpectrumDensity();

% Построить созвездие
analyzer.plotPayloadConstellation();



