classdef MVI_Report < mlreportgen.dom.Document
    %MYREPORT defines a customize letter to customers
    %
    % rpt = MyReport('mydoc','docx','CustomerLetter');
    % rpt.CustomerName = 'Smith';
    % fill(rpt);
    
    properties
        subj_ID;
        date;
        visitnum;
        testname;
%         testcond;
        raw_filename;
        examiner;
        cyc_avg_plot
        cyc_avg_legend
        lhrh_data_table;
        larp_data_table;
        ralp_data_table;
        file_info_table;
    end
    
    methods
        function rpt = MVI_Report(filename,type,template)
            rpt = rpt@mlreportgen.dom.Document(filename,type,template);
        end
        
        function fillsubj_ID(rpt)
            append(rpt,rpt.subj_ID);
        end
        
        function filldate(rpt)
            append(rpt,rpt.date);
        end
        
        function fillvisitnum(rpt)
            append(rpt,rpt.visitnum);
        end
        
        function filltestname(rpt)
            append(rpt,rpt.testname);
        end
        
%         function filltestcond(rpt)
%             append(rpt,rpt.testcond);
%         end
        
        function fillraw_filename(rpt)
            append(rpt,rpt.raw_filename);
        end
        
        function fillexaminer(rpt)
            append(rpt,rpt.examiner);
        end
        
        function fillcyc_avg_plot(rpt)
            
            import mlreportgen.dom.*;
            
            img = Image(rpt.cyc_avg_plot);
            img.Style = {ScaleToFit};
            
            p = Paragraph( '', 'AR_Image' );
            append(p, img);
            append(rpt, p);
        end
        
        function fillcyc_avg_legend(rpt)
            
            import mlreportgen.dom.*;
            
            img = Image(rpt.cyc_avg_legend);
            %             img.Style = {ScaleToFit};
            img.Height = '3cm';
            img.Width = '5cm';
            p = Paragraph( '', 'AR_Image' );
            append(p, img);
            append(rpt, p);
        end
        
        function filllhrh_data_table(rpt)
            import mlreportgen.dom.*;
            
            tableData = rpt.lhrh_data_table;
            
            numCol = size(tableData,2);
            numRow = size(tableData,1);
            %The FormalTable class allows us to build a complete table from scratch.
            %We need to provide the number of columns in the constructor
            table = FormalTable( numCol );
            %The table shall span the page width, so we set the attribute to 100%
            table.Width = '100%';
            table.Border = 'thick';
            table.BorderColor = 'black';
            table.ColSep = 'solid';
            table.ColSepColor = 'black';
            table.RowSep = 'solid';
            table.RowSepColor = 'black';
            %Now we need to create a TableRow object for each row we want to add.
            %This loop is for adding a table header which shall be displayed in bold
            row = TableRow();
            for nc=1:numCol
                %We create a Text for each colum in the header and make it bold
                textObj = Text(num2str(tableData{1,nc}));
                textObj.Bold = true;
                te = TableEntry( textObj );
                te.Children.FontSize = '9';
                %Then a TableEntry is added to the TableRow for each column
                append(row, te );
            end
            %This row is appended to the table-header
            append(table.Header, row);
            
            %This loop fills the table body
            for nr=2:numRow
                row = TableRow();
                for nc=1:numCol
                    if (nc == 4) || (nc == 7) || (nc == 10) || (nc == 13)
                        te = TableEntry( num2str(tableData{nr,nc},'%10.0f') );
                    else
                        te = TableEntry( num2str(tableData{nr,nc},'%10.1f') );
                    end                    %The BackgroundColor of each TableEntry shall be filled with a
                    %random color.
                    %                     bgColor = sprintf('#%x', randi(16777215));
                    %                     te.Style  = { BackgroundColor(bgColor) };
                    if nc==1
                        te.Children.Bold = true;
                    end
                    
                    te.VAlign = 'middle';
                    te.Children.FontSize = '9';
                    append(row, te );
                end
                append(table.Body, row);
            end
            append(rpt, table);
            
            
        end
        function filllarp_data_table(rpt)
            import mlreportgen.dom.*;
            
            tableData = rpt.larp_data_table;
            
            numCol = size(tableData,2);
            numRow = size(tableData,1);
            %The FormalTable class allows us to build a complete table from scratch.
            %We need to provide the number of columns in the constructor
            table = FormalTable( numCol );
            %The table shall span the page width, so we set the attribute to 100%
            table.Width = '100%';
            table.Border = 'thick';
            table.BorderColor = 'black';
            table.ColSep = 'solid';
            table.ColSepColor = 'black';
            table.RowSep = 'solid';
            table.RowSepColor = 'black';
            %Now we need to create a TableRow object for each row we want to add.
            %This loop is for adding a table header which shall be displayed in bold
            row = TableRow();
            for nc=1:numCol
                %We create a Text for each colum in the header and make it bold
                textObj = Text(num2str(tableData{1,nc}));
                textObj.Bold = true;
                te = TableEntry( textObj );
                te.Children.FontSize = '9';
                %Then a TableEntry is added to the TableRow for each column
                append(row, te );
            end
            %This row is appended to the table-header
            append(table.Header, row);
            
            %This loop fills the table body
            for nr=2:numRow
                row = TableRow();
                for nc=1:numCol
                    if (nc == 4) || (nc == 7) || (nc == 10) || (nc == 13)
                        te = TableEntry( num2str(tableData{nr,nc},'%10.0f') );
                    else
                        te = TableEntry( num2str(tableData{nr,nc},'%10.1f') );
                    end
                    %The BackgroundColor of each TableEntry shall be filled with a
                    %random color.
                    %                     bgColor = sprintf('#%x', randi(16777215));
                    %                     te.Style  = { BackgroundColor(bgColor) };
                    if nc==1
                        te.Children.Bold = true;
                    end
                    
                    te.VAlign = 'middle';
                    te.Children.FontSize = '9';
                    append(row, te );
                end
                append(table.Body, row);
            end
            append(rpt, table);
            
            
        end
        function fillralp_data_table(rpt)
            import mlreportgen.dom.*;
            
            tableData = rpt.ralp_data_table;
            
            numCol = size(tableData,2);
            numRow = size(tableData,1);
            %The FormalTable class allows us to build a complete table from scratch.
            %We need to provide the number of columns in the constructor
            table = FormalTable( numCol );
            %The table shall span the page width, so we set the attribute to 100%
            table.Width = '100%';
            table.Border = 'thick';
            table.BorderColor = 'black';
            table.ColSep = 'solid';
            table.ColSepColor = 'black';
            table.RowSep = 'solid';
            table.RowSepColor = 'black';
            %Now we need to create a TableRow object for each row we want to add.
            %This loop is for adding a table header which shall be displayed in bold
            row = TableRow();
            for nc=1:numCol
                %We create a Text for each colum in the header and make it bold
                textObj = Text(num2str(tableData{1,nc}));
                textObj.Bold = true;
                te = TableEntry( textObj );
                te.Children.FontSize = '9';
                %Then a TableEntry is added to the TableRow for each column
                append(row, te );
            end
            %This row is appended to the table-header
            append(table.Header, row);
            
            %This loop fills the table body
            for nr=2:numRow
                row = TableRow();
                for nc=1:numCol
                    if (nc == 4) || (nc == 7) || (nc == 10) || (nc == 13)
                        te = TableEntry( num2str(tableData{nr,nc},'%10.0f') );
                    else
                        te = TableEntry( num2str(tableData{nr,nc},'%10.1f') );
                    end                    %The BackgroundColor of each TableEntry shall be filled with a
                    %random color.
                    %                     bgColor = sprintf('#%x', randi(16777215));
                    %                     te.Style  = { BackgroundColor(bgColor) };
                    if nc==1
                        te.Children.Bold = true;
                    end
                    
                    te.VAlign = 'middle';
                    te.Children.FontSize = '9';
                    append(row, te );
                end
                append(table.Body, row);
            end
            append(rpt, table);
            
            
        end
        
        
        
        
        function fillfile_info_table(rpt)
            import mlreportgen.dom.*;
            
            tableData = rpt.file_info_table;
            
            numCol = size(tableData,2);
            numRow = size(tableData,1);
            %The FormalTable class allows us to build a complete table from scratch.
            %We need to provide the number of columns in the constructor
            table = FormalTable( numCol );
            %The table shall span the page width, so we set the attribute to 100%
            table.Width = '100%';
            table.Border = 'thick';
            table.BorderColor = 'black';
            table.ColSep = 'solid';
            table.ColSepColor = 'black';
            table.RowSep = 'solid';
            table.RowSepColor = 'black';
            %Now we need to create a TableRow object for each row we want to add.
            %This loop is for adding a table header which shall be displayed in bold
            row = TableRow();
            for nc=1:numCol
                %We create a Text for each colum in the header and make it bold
                textObj = Text(num2str(tableData{1,nc}));
                textObj.Bold = true;
                te = TableEntry( textObj );
                te.Children.FontSize = '9';
                %Then a TableEntry is added to the TableRow for each column
                append(row, te );
            end
            %This row is appended to the table-header
            append(table.Header, row);
            
            %This loop fills the table body
            for nr=2:numRow
                row = TableRow();
                for nc=1:numCol
                    
                        te = TableEntry(num2str(tableData{nr,nc}));
                    %random color.
                    %                     bgColor = sprintf('#%x', randi(16777215));
                    %                     te.Style  = { BackgroundColor(bgColor) };
                    if nc==1
                        te.Children.Bold = true;
                    end
                    
                    te.VAlign = 'middle';
                    te.Children.FontSize = '9';
                    append(row, te );
                end
                append(table.Body, row);
            end
            append(rpt, table);
            
            
        end
    end
    
end