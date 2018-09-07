function plotIC

p = pinParams;
x = meshgen_x(p);

for i = 1:length(x)
% p-type
    if x(i) < (p.tp - p.wp)
    
       u0(:, i) = [p.PhiA;
             p.PhiA;
              p.NI;
              0];  

    % p-type SCR    
    elseif  x(i) >= (p.tp - p.wp) && x(i) < p.tp

        u0(:, i) = [p.PhiA;
             p.PhiA;
              p.NI;
              (((p.q*p.NA)/(2*p.eppi*p.epp0))*(x(i)-p.tp+p.wp)^2)];

    % Intrinsic

    elseif x(i) >= p.tp && x(i) < p.tp+ p.ti

        u0(:, i) =  [p.PhiA;
             p.PhiA;
                p.NI;
                ((x(i) - p.tp)*((1/p.ti)*(p.Vbi - ((p.q*p.NA*p.wp^2)/(2*p.eppi*p.epp0)) - ((p.q*p.ND*p.wn^2)/(2*p.eppi*p.epp0))))) + ((p.q*p.NA*p.wp^2)/(2*p.eppi*p.epp0)) ;];

    % n-type SCR    
    elseif  x(i) >= (p.tp+p.ti) && x(i) < (p.tp + p.ti + p.wn)

        u0(:, i) = [p.PhiA;
             p.PhiA;
              p.NI;
              (((-(p.q*p.ND)/(2*p.eppi*p.epp0))*(x(i)-p.tp - p.ti -p.wn)^2) + p.Vbi)]; 

    % n-type
    elseif x(i) >= (p.tp + p.ti + p.wn) %&& x(i) <= p.xmax

         u0(:, i) = [p.PhiA;
             p.PhiA;
               p.NI;
               p.Vbi];
    end     
    
end

figure
plot(x, u0(1,:), x, u0(2,:), x, p.EA-u0(4,:), x, p.IP-u0(4,:))
xlabel('Position [cm]')
ylabel('Energy [eV]')


end