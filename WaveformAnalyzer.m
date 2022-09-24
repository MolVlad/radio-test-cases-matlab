classdef WaveformAnalyzer < handle
    %% Описание класса
    %
    % 1. Класс читает данные (во временной области) на выходе OFDM модулятора сигнала, а также информацию о параметрах формирователя
    %
    % 2. Строит метрики: спектральная плотность мощности в частотной области, графическое представление созвездия на комплексной плоскости,
    % среднеквадратичное значение модуля вектора ошибки (EVM)
    %
    % Входные данные:
    %
    % waveformSamples - массив содержащий отчеты baseband сигнала во временной области на выходе OFDM модулятора
    %
    % waveformInfo - структура с параметрами OFDM модулятора и пейлоуда:
    %       Nfft               - кол-во спектрально-временных отчетов дискретного преобразования Фурье
    %       sampleRate         - частота семплирования [Гц]
    %       cyclicPrefixLengths/SymbolLengths - длины циклического преффикса и OFDM символов [кол-во временных отчетов]
    %       symbolsCount       - кол-во символов на слот радиокадра
    %       subCarriersCount   - кол-во поднесущих
    %       payloadSymbols     - информационные символы
    %       payloadSymbolsIdxs - индексы ресурсных элементов отведенные для передачи payloadSymbols
    %
    % Поля класса:
    %
    %       rmsEvm            - среднеквадратичное значение модуля вектора ошибки
    %       waveformMeanPower - среднеквадратичное значение мощности сигнала
    %       channelBandwidth  - ширина полосы канала в дБ
    %       noiseMeanPower    - среднеквадратичное значение мощности шума в разах
    %       modulationType    - тип модуляционной схемы
    %       waveformDuration  - длина анализируемого сигнала в секундах
    %

    properties
        rmsEvm
        waveformMeanPower
        channelBandwidth
        noiseMeanPower
        modulationType
        waveformDuration
    end

    properties (Access = private)
        waveformSource        
        Nfft
        sampleRate
        cyclicPrefixLengths
        symbolLengths
        symbolsCount
        subCarriersCount
        payloadSymbols
        payloadSymbolsIdxs
    end
    
    methods
        function this = WaveformAnalyzer(waveformSource, waveformInfo)
            % Конструктор класса. Чтение waveform-ы во временной области и структуры с информацией
            % необходимой для дальнейшей обработки данных и заполнения полей класса
            
            % Сохранить отсчеты сигнала
            this.waveformSource = waveformSource;
            
            % Сохранить параметры, считанные из структуры
            this.Nfft = waveformInfo.Nfft;
            this.sampleRate = waveformInfo.SampleRate;
            this.cyclicPrefixLengths = waveformInfo.CyclicPrefixLengths;
            this.symbolLengths = waveformInfo.SymbolLengths;
            this.symbolsCount = waveformInfo.symbolsCount;
            this.subCarriersCount = waveformInfo.subCarriersCount;
            this.payloadSymbols = waveformInfo.payloadSymbols;
            this.payloadSymbolsIdxs = waveformInfo.payloadSymbolsIdxs;
        end

        function calcWaveformParameters(this)
            % Рассчитать среднюю мощность сигнала
            this.waveformMeanPower = mean(abs(this.waveformSource).^2);
            
            % Рассчитать полосу сигнала
            this.channelBandwidth = this.sampleRate;
            
            % Распознать тип модуляции
            switch length(unique(this.payloadSymbols))
                case 64
                    this.modulationType = "QAM-64";
                otherwise
                    error("Неизвестная модуляция");
            end
            
            % Рассчитать длительность сигнала
            this.waveformDuration = length(this.waveformSource) / this.sampleRate;
        end

        function plotPowerSpectrumDensity(this)
            % Получить частоты сигнала
            waveformLength = length(this.waveformSource);
            frequencies = (-waveformLength/2:waveformLength/2-1)*(this.sampleRate/waveformLength);
            
            % Построить спектральную плотность мощности
            figure;
            plot(frequencies, pow2db(abs(fftshift(fft(this.waveformSource))).^2));
            xlabel("Frequency, Hz");
            ylabel("Power, dB");
            grid on;
            title("Power spectrum density");
        end

        function plotPayloadConstellation(this)
            % Построить созвездие
            scatterplot(this.payloadSymbols);
            title("Constellation");
        end

        function calcEvmPerformance(this)

        end
    end
end