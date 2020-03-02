function newfile = replacevp(filename)
% v1
% remplace les virgules en points

fid = fopen(filename,'r');
texte = fread(fid,inf,'char');
fclose(fid);
% Conversion des virgules (caractère 44) en points (caractère 46)
texte(texte == 44) = 46;
% Sauvegarde du fichier dans un fichier temporaire au bon format
fid = fopen('fictmp.txt','w');
fseek(fid,0,-1);
fwrite(fid,texte,'char');
fclose(fid);

newfile = 'fictmp.txt';