function newfile = replacepv(filename)
%remplace les virgules en points

fid = fopen(filename,'r');
texte = fread(fid,inf,'char');
fclose(fid);
% Conversion des points (caractère 46) en virgules (caractère 44)
texte(find(texte == 46)) = 44;
% Sauvegarde du fichier dans un fichier temporaire au bon format
fid = fopen('fictmp.txt','wb');
fseek(fid,0,-1);
fwrite(fid,texte,'char');
fclose(fid);

newfile = 'fictmp.txt';