lag = arburg(rot_u_0204_1,1);
lag2 = lag(2);
lag3 = abs(lag2);

%[signif,fft_theor] = wave_signif(rot_u_0204_1,1,scale,1,lag3,0.95,length(rot_u_0204_1));
[signif,fft_theor] = wave_signif(rot_u_0204_1,1,scale,0,lag3,0.95);
% neue matrix berechnen um im bild die bereiche zu kennzeichnen, die vertrauenswert sind.

einsen=ones(length(wave(:,1)),length(wave(1,:)));
% sig_matrix=zeros(length(wave(:,1)),length(wave(1,:)));
% for i=length(wave(1,:))
%     sig_matrix(:,i)=einsen(:,i).*signif';
% end


for i=1:length(rot_u_0204_1);
    sig_matrix(:,i)=signif';
end

over_matrix=abs(wave).^2-sig_matrix;

for i=1:length(wave(1,:));
    for j=1:length(wave(:,1));
        if over_matrix(j,i) > 0;
            over_matrix(j,i)=1.5;
        else over_matrix(j,i)=0;
        end
    end
end

