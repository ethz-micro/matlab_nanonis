function [noise_fit,signal_start,signal_error, noise_coeff] =getRadialNoise(wavelength, radial_average,varargin)
    % This function tries to extract the noise from the data
    % it takes the radius and the corresponding amplitude. 
    % The third argument is the max number of noises it tries to find (default = 10)
    
    
    %Get first noise
    [noise_fit, noise_coeff,signal_start,signal_error, signal_idx] =getSingleNoise(wavelength, radial_average,nan);
    
    %If the signal idx <3, there is probably nothing. (Try again with bigger image)
    if signal_idx<3
        signal_start=nan;
        signal_error=[nan,nan];
        noise_fit=noise_fit.*nan;
        noise_coeff=noise_coeff.*nan;
        
    %else, try to find additional noise    
    else
        %loop counter
        i=1;
        %Read max noise number
        maxNbrNoise=10;
        if nargin>2
            maxNbrNoise = varargin{1};
        end
        
        %Try to find additional noise
        while signal_idx>5 && i<maxNbrNoise %need at least 5 points to work
            i=i+1;
            %Compute noise on remaining data
            [noise_fit_j, noise_coeff_j,signal_start_j,signal_error_j, signal_idx_j] = ...
                getSingleNoise(wavelength(1:signal_idx), radial_average(1:signal_idx),noise_fit(signal_idx));
            
            %If fit sucessful
            if ~isnan(signal_start_j)
                
                %save new noise part
                noise_fit(1:signal_idx)=noise_fit_j;
                if signal_idx==numel(wavelength)
                    noise_coeff=noise_coeff_j;
                end
                
                %if signal detected
                if signal_idx_j>2
                    %save data
                    signal_start=signal_start_j;
                    signal_error=signal_error_j;
                    
                else % no signal
                    signal_start=nan;
                    signal_error=[nan,nan];
                end
            else % can't fit noise, end the loop
                signal_idx_j=0;
            end
            %save signal idx for next loop
            signal_idx=signal_idx_j;
        end
    end
end

function [noise_fit, noise_coeff,signal_start,signal_error, signal_idx] =getSingleNoise(wavelength, radial_average,last_point)
    %Find a single noise on the data
    
    %init variables
    old_signal_idx=nan;
    old_sign=nan;
    new_sign=nan;
    signal_idx=floor(3*numel(wavelength)/4);
    noise_coeff=[nan,nan];
    
    %fit the noise from signal_idx to end. signal_idx is deduced from the
    %noise. Therefore do a loop
    while old_signal_idx ~=signal_idx && -new_sign~=old_sign;%end loop if found a stable point or if switches direction
        %data from previous loop
        old_sign=new_sign;
        old_signal_idx=signal_idx;
        old_slope=noise_coeff(1);
        
        %new data
        [signal_idx,noise_fit, noise_coeff]=getNoiseCut(wavelength, radial_average,signal_idx,last_point);
        new_sign=sign(noise_coeff(1)-old_slope);
    end
    
    %init values
    signal_start=nan;
    signal_error=[nan,nan];
    
    % if point found
    if ~isnan(signal_idx)
        %If it is the first one, there is no signal, or no noise
        if signal_idx == 1
            %if there is no signal, we should go to the next part,
            %otherwise the noise is treated as signal
            %Here a test for the signal
            
            if find(radial_average./noise_fit>1,1,'first') < 5;%if there is less than 5 points below, it is noise probably
                if std(radial_average./noise_fit)<0.2% if std is small, it is noise probably
                    signal_idx=2;%anyway it is better to assume this is noise
                end
            end
        end
        %Otherwise, we have detected a new noise
        if signal_idx>1 && signal_idx<numel(wavelength)-1
            %get the signal position and error
            signal_start=wavelength(signal_idx-1);
            signal_error(1)=abs(wavelength(signal_idx-1)-wavelength(signal_idx));%L
            if signal_idx>2
                signal_error(2)=abs(wavelength(signal_idx-2)-wavelength(signal_idx-1));%U
            else
                signal_error(2)=signal_error(1);
            end
        end
    end
end

function [signal_idx,noise_fit, noise_coeff] =getNoiseCut(wavelength, radial_average,cutIdx,last_point)
    
    X=log(wavelength(cutIdx:end));
    Y=log(radial_average(cutIdx:end));
    %fit
    if isnan(last_point)
        noise_coeff=polyfit(X,Y,1);
    else
        %least squares fit
        Xp=(X-X(end));
        Yp=(Y-log(last_point));
        a=sum(Xp.*Yp)/sum(Xp.^2);%least square best function
        if isnan(a)%All data on the same line (all X=Xend)
            a=0;
        end
        noise_coeff(1)=a;
        noise_coeff(2)=log(last_point)-a*X(end);
    end
    noise_fit=wavelength.^(noise_coeff(1)).*exp(noise_coeff(2));
    
    %Compute the ratio
    radial_ratio=radial_average./noise_fit;
    
    %Find first point <1, ignore first point
    signal_idx=find(radial_ratio(2:end)<1,1,'first')+1;
    if isempty(signal_idx)%Should not happen
        signal_idx=nan;
    elseif signal_idx <4%if <4, do not ignore first point
        signal_idx=find(radial_ratio<1,1,'first');
    end
end
