function out = Formattable(tbl)
out = tbl;
for i = 1:width(tbl)
  if iscellstr(tbl{:,i}) || isstring(tbl{:,i})
    out.(out.Properties.VariableNames{i}) = categorical(tbl{:,i});
  end
end
end