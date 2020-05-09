%*********************************************
% Nokia RTTL Composer: User has to enter his
% note in a string and the output is a
% <note_name>.wav file that can be played
%*********************************************
 

 % Taking the note as input from the user %
noteStr = input('Enter your RTTTL Note: ', 's');

    % ***Some processing on the note string to separate its sections*** %
        % Section 1. Name
        %         2. Defaults (Duration, Octave, Tempo)
        %         3. Note
    
        
% Getting note name %
note_name = extractBefore (noteStr,':'); 

% Getting note default values and storing them in an array of strings
% note_defaults -> (1) = Duration
%                  (2) = Octave
%                  (3) = Tempo

dfs = extractBetween (noteStr,':',':');
note_defaults = split (dfs,',');
for index = 1:length(note_defaults)
    note_defaults(index) = extractAfter(note_defaults(index),'=');
end

% Getting the entered note and splitting it into
% multiple strings stored inside an array
note= extractAfter (noteStr,':');
note= extractAfter (note,':');
note = split (note,',');
note_char = char(note);

% Checking if a single note has the duration at its start. If yes, do
% nothing. If no, add the default duration at the first of the note.
for index = 1:length(note_char)
        element = string(note_char(index,1));
        if ((element >= string ('A') && element <= string ('Z')) || (element >= string ('a') && element <= string ('z')))
        note(index) = strcat(note_defaults(1),note(index));
        end
end
note_char = char(note);

% Checking if a single note has the octave at its end. If yes, do
% nothing. If no, add the default octave at the last of the note.
for index = 1:length(note_char)
        last=strlength(note(index));
        element = string(note_char(index,last));
        if ((element >= string ('A') && element <= string ('Z')) || (element >= string ('a') && element <= string ('z')) || element == string('#') || element == string('.'))
        note(index) = strcat(note(index),note_defaults(2));
        end
end
note_char = char(note);

% It's required to to get each note letter to determine the frequency
% of each note, so, we'll iterate on each note to extract the letter.
Idix = 1;
note_fr = string('0');
for index = 1:length(note_char)
    for indexx = 1:strlength(note(index))
        element = string(note_char(index,indexx));
        if ((element >= string ('A') && element <= string ('Z')) || (element >= string ('a') && element <= string ('z')))
            if (note_char(index,indexx+1) == '#')
                 note_fr(Idix) = string(strcat(element,note_char(index,indexx+1)));
                 Idix = Idix + 1;
            else
                note_fr(Idix)= element;
                Idix = Idix +1;
            end
            break;
        end
    end
end
note_fr = note_fr.';
note_char = char(note);

% It's required to to get each note octave to determine the frequency
% of each note, so, we'll iterate on each note to extract the octave.
note_o = string('0');
for index = 1:length(note_fr)
    note_o(index) = str2double(note_char(index,strlength(note(index))));
end
note_o = note_o.';
note_o = str2double(note_o);


% To get the frequency of each note in the array, we must iterate on
% each letter and find it's corresponding octave number to calculate frequency.
%
%  $$$$$$$$$  Octave = 4 $     
%  $$$$$$$$$$$$$$$$$$$$$$$      We will need only values at Octave = 4
% 1.   A   $  220 Hz     $      Octave (5)= 2 * Octave (4) 
% 2.   A#  $  233.082 Hz $      Octave (6)= 4 * Octave (4)
% 3.   B   $  246.942 Hz $      Octave (7)= 8*  Octave (4)
% 4.   C   $  261.626 Hz $      So, we can substitute with    
% 5.   C#  $  277.183 Hz $      Frequency = Base * 2^(Octave - 4)
% 6.   D   $  293.665 Hz $
% 7.   D#  $  311.127 Hz $
% 8.   E   $  329.628 Hz $
% 9.   F   $  349.228 Hz $
% 10.  F#  $  369.994 Hz $
% 11.  G   $  391.995 Hz $
% 12.  G#  $  415.305 Hz $
% $$$$$$$$$$$$$$$$$$$$$$$$


for index = 1:length(note_fr)
    
    if (note_fr(index) == (string('A')) || note_fr(index) == (string('a')) )
        note_fr(index)=220 * 2^(note_o(index) - 4);
    elseif (note_fr(index) == (string('A#')) || note_fr(index) == (string('a#')) )
        note_fr(index)=233.082 * 2^(note_o(index) - 4);
    elseif (note_fr(index) == (string('B')) || note_fr(index) == (string('b')) )
        note_fr(index)=246.942 * 2^(note_o(index) - 4);
    elseif (note_fr(index) == (string('C')) || note_fr(index) == (string('c')) )
        note_fr(index)=261.626 * 2^(note_o(index) - 4);
    elseif (note_fr(index) == (string('C#')) || note_fr(index) == (string('c#')) )
        note_fr(index)=277.138 * 2^(note_o(index) - 4);
    elseif (note_fr(index) == (string('D')) || note_fr(index) == (string('d')) )
        note_fr(index)=293.665 * 2^(note_o(index) - 4);
    elseif (note_fr(index) == (string('D#')) || note_fr(index) == (string('d#')) )
        note_fr(index)=311.127 * 2^(note_o(index) - 4);
    elseif (note_fr(index) == (string('E')) || note_fr(index) == (string('e')) )
        note_fr(index)=329.628 * 2^(note_o(index) - 4);
    elseif (note_fr(index) == (string('F')) || note_fr(index) == (string('f')) )
        note_fr(index)=349.228 * 2^(note_o(index) - 4);
    elseif (note_fr(index) == (string('F#')) || note_fr(index) == (string('f#')) )
        note_fr(index)=369.994 * 2^(note_o(index) - 4);
    elseif (note_fr(index) == (string('G')) || note_fr(index) == (string('g')) )
        note_fr(index)=391.995 * 2^(note_o(index) - 4);
    elseif (note_fr(index) == (string('G#')) || note_fr(index) == (string('g#')) )
        note_fr(index)=(415.305 * 2^(note_o(index) - 4));
    else
        note_fr(index)= 0;
    end
end
note_fr=str2double(note_fr);