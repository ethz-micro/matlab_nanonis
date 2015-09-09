function [noise_fit,signal_start,signal_error, noise_coeff] =getRadialNoise(radius, radial_average)
    %Init values
    [noise_fit, noise_coeff,signal_start,signal_error, signal_idx] =getSingleNoise(radius, radial_average,nan);
    
    if signal_idx<3
        signal_start=nan;
        signal_error=[nan,nan];
        
    else
        i=1;
        %Do loop
        while signal_idx>5%need at least 5 points to work
            i=i+1;
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
                    signal_error=[nan,nan];
                end
            else % can't fit noise, end the loop
                signal_idx_j=0;
            end
            signal_idx=signal_idx_j;
        end
    end
end

function [noise_fit, noise_coeff,signal_start,signal_error, signal_idx] =getSingleNoise(radius, radial_average,last_point)
    
    %loop while old cut != new cut
    %find noise
    %find cut
    
    old_signal_idx=nan;
    old_sign=nan;
    new_sign=nan;
    signal_idx=floor(3*numel(radius)/4);
    noise_coeff=[nan,nan];
    
    %figure
    while old_signal_idx ~=signal_idx && -new_sign~=old_sign;
        old_sign=new_sign;
        old_signal_idx=signal_idx;
        old_slope=noise_coeff(1);
        
        [signal_idx,noise_fit, noise_coeff]=getNoiseCut(radius, radial_average,signal_idx,last_point);
        new_sign=sign(noise_coeff(1)-old_slope);
        
        %loglog(radius,radial_average)
        %hold on
        %loglog(radius,noise_fit)
        %pause
    end
    
    %init values
    signal_start=nan;
    signal_error=[nan,nan];
    
    % if point found
    if ~isnan(signal_idx)
        if signal_idx == 1
            %if there is no signal, we should go to the next part
            %Here a test for the signal
            
            if find(radial_average./noise_fit>1,1,'first') < 5;%if there is less than 5 points below, it is noise probably
                if std(radial_average./noise_fit)<0.2% if std is small, it is noise probably
                    signal_idx=2;%anyway it is better to assume this is noise
                end
            end
        end
        %If it is the first one, there is no signal, or no noise
        if signal_idx>1 && signal_idx<numel(radius)-1
            signal_start=1./radius(signal_idx-1);
            signal_error(1)=abs(1./radius(signal_idx-1)-1./radius(signal_idx));%L
            if signal_idx>2
                signal_error(2)=abs(1./radius(signal_idx-2)-1./radius(signal_idx-1));%U
            else
                signal_error(2)=signal_error(1);
            end
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
