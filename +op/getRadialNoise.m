function [noise_fit,signal_start,signal_error, noise_coeff] =getRadialNoise(radius, radial_average)
    %Init values
    [noise_fit, noise_coeff,signal_start,signal_error, signal_idx] =getSingleNoise(radius, radial_average,nan);
    
    if signal_idx<3
        signal_start=nan;
        signal_error=nan;
        
    else
        %Do loop
        while signal_idx>5%need at least 5 points to work
            %Compute noise on remaining data
            [noise_fit_j, noise_coeff_j,signal_start_j,signal_error_j, signal_idx_j] =getSingleNoise(radius(1:signal_idx), radial_average(1:signal_idx),noise_fit(signal_idx));
            
            %If fit sucessful
            if ~isnan(signal_start_j)
                %save noise
                noise_fit(1:signal_idx)=noise_fit_j;
                if signal_idx==numel(radius)
                    noise_coeff=noise_coeff_j;
                end
                
                %if signal detected
                if signal_idx_j>2
                    %save data
                    signal_start=signal_start_j;
                    signal_error=signal_error_j;
                    
                else % no signal
                    signal_start=nan;
                    signal_error=nan;
                end
            else % can't fit noise, end the loop
                signal_idx_j=0;
            end
            signal_idx=signal_idx_j;
        end
    end
end

function [noise_fit, noise_coeff,signal_start,signal_error, signal_idx] =getSingleNoise(radius, radial_average,last_point)
    sigNbr=1+3; %need two points to detect signal
    
    %loop while old cut != new cut
    %find noise
    %find cut
    
    old_signal_idx=nan;
    old_sign=nan;
    signal_idx=floor(numel(radius)/2);
    %figure
    while old_signal_idx ~=signal_idx && -sign(signal_idx-old_signal_idx)~=old_sign;
        old_sign=sign(signal_idx-old_signal_idx);
        old_signal_idx=signal_idx;
        [signal_idx,noise_fit, noise_coeff]=getNoiseCut(radius, radial_average,signal_idx,last_point);
        %loglog(radius,radial_average)
        %hold on
        %loglog(radius,noise_fit)
        %pause
    end
    
    %init values
    signal_start=nan;
    signal_error=nan;
    
    % if point found
    if ~isnan(signal_idx)
        if signal_idx == 1
            %separate by finding first >1 and expect <5 points for no
            %signal
            if find(radial_average./noise_fit>1,1,'first') < sigNbr;
                signal_idx=2;
                
            end
        end
        %If it is the first one, there is no signal, or no noise
        if signal_idx>1 && signal_idx<numel(radius)-1
            signal_start=1./radius(signal_idx-1);
            signal_error=abs(1./radius(signal_idx-1)-1./radius(signal_idx));
        end
    end
end

function [signal_idx,noise_fit, noise_coeff] =getNoiseCut(radius, radial_average,cutIdx,last_point)
    X=log(radius(cutIdx:end));
    Y=log(radial_average(cutIdx:end));
    %fit
    if isnan(last_point)
        noise_coeff=polyfit(X,Y,1);
    else
        myfit=fit((X-X(end))',(Y-log(last_point))','a*x','StartPoint',0);
        a=myfit.a;
        noise_coeff(1)=a;
        noise_coeff(2)=log(last_point)-a*X(end);
    end
    noise_fit=radius.^(noise_coeff(1)).*exp(noise_coeff(2));
    
    %Compute the ratio
    radial_ratio=radial_average./noise_fit;
    
    %Find first point <1
    signal_idx=find(radial_ratio(2:end)<1,1,'first')+1;
    if isempty(signal_idx)
        signal_idx=nan;
    elseif signal_idx <4
        signal_idx=find(radial_ratio<1,1,'first');
    end
end
