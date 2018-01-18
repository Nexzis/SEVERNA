	function f1()
	
	-- ��������� ���������� �������������:

	local userArchTypeHour = false;		-- ��� ������ �������� ������������� - �������
	local userArchTypeDate = true;		-- ��� ������ �������� ������������� - ��������	
	local userArchTypeMonth = false;	-- ��� ������ �������� ������������� - ��������

	local fdHour_1;		-- ���������� ����� �������� ������ ��������� ����� 1
	local fdDate_1;		-- ���������� ����� ��������� ������ ��������� ����� 1
	local fdMonth_1;	-- ���������� ����� ��������� ������ ��������� ����� 1

	local fdHour_2;		-- ���������� ����� �������� ������ ��������� ����� 2
	local fdDate_2;		-- ���������� ����� ��������� ������ ��������� ����� 2
	local fdMonth_2;	-- ���������� ����� ��������� ������ ��������� ����� 2

	-- local pathHour_1 = "C:/!Projects/Energy_Accounting_T_v4/ArchiveFiles/HourArchive_1.txt";
	-- local pathDate_1 = "C:/!Projects/Energy_Accounting_T_v4/ArchiveFiles/DateArchive_1.txt";
	-- local pathMonth_1 = "C:/!Projects/Energy_Accounting_T_v4/ArchiveFiles/MonthArchive_1.txt";
	
	-- local pathHour_2 = "C:/!Projects/Energy_Accounting_T_v4/ArchiveFiles/HourArchive_2.txt";
	-- local pathDate_2 = "C:/!Projects/Energy_Accounting_T_v4/ArchiveFiles/DateArchive_2.txt";
	-- local pathMonth_2 = "C:/!Projects/Energy_Accounting_T_v4/ArchiveFiles/MonthArchive_2.txt";
	
	local pathHour_1 = "C:/SPT943_ArchiveFiles/HourArchive_1.txt";
	local pathDate_1 = "C:/SPT943_ArchiveFiles/DateArchive_1.txt";
	local pathMonth_1 = "C:/SPT943_ArchiveFiles/MonthArchive_1.txt";
	
	local pathHour_2 = "C:/SPT943_ArchiveFiles/HourArchive_2.txt";
	local pathDate_2 = "C:/SPT943_ArchiveFiles/DateArchive_2.txt";
	local pathMonth_2 = "C:/SPT943_ArchiveFiles/MonthArchive_2.txt";
	
	function readLastDate( fd)
		local pos;
		local str;
		-- ����������� ���� ��������� ������ ������      		
				pos = fd:seek( "end");
				pos = fd:seek( "set", pos - 3);
				for i = 1, 50 do
					pos = fd:seek( "set", pos - 1);
					str = fd:read( "*L");
					if str == "\n" then 
						  pos = fd:seek( "set", pos - 11);
						  str = fd:read( "*l");
						  break;
					end
				end
		return str;
	end

	fd = io.open( pathDate_1, "r");								-- ������� ���� ��������� ������ ��1 �� ������
	if fd == nil then											-- �������� �������� ����� ��������� ������ ��1
		Core.SPT943_Driver_Msg = "������ �������� ����� ��������� ������ ��1!";
		Core.addLogMsg( "bu: ������ �������� ����� ��������� ������ ��1!");
		return -1;
	end
	
	local ret = readLastDate( fd);

	--local userStartDate = tostring( Core.StartDate - 10800);
	local userStartDate = tonumber( ret) + 86400;		
	Core.addLogMsg( "f1: userStartDate => " .. userStartDate);
	
	local userEndDate = userStartDate + 86400;
	Core.addLogMsg( "f1: userEndDate => " .. userEndDate);

	-- ���������������� ���������:
	local portName = "COM7";	-- ��� �����
	local baudRate = 2400;		-- �������� ������
	local dataBits = 8;			-- ���������� ��� ������
	local stopBits = 1;			-- ���������� ����-���	
	local parity = "NONE";		-- �������

	local serialPort;

	-- ��� ������ - ������� (respArchType = 0), �������� (respArchType = 1), �������� (respArchType = 3)
	local respArchType;		--	��� ������ � ������

	-- ������ ������������� ������ �����
	local initSessionStr = string.char( 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
								0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF);

	--	������ ������� ������ ����� (�����٨���� ������ ���������)
	local reqSessionShortStr = string.char( 0x10, 0xFF, 0x3F, 0x00, 0x00, 0x00, 0x00, 0xC1, 0x16);
	--	������ ������� ������ ����� (������� ������ ���������)
	local reqSessionFullStr = string.char( 0x10, 0xFF, 0x90, 0x00, 0x00, 0x05, 0x00, 0x3F, 0x00, 0x00, 0x00, 0x00, 0xD9, 0x19);
	--	������ ������� ��������� �������� ������
	local reqBaudRateStr = string.char( 0x10, 0xFF, 0x90, 0x00, 0x00, 0x05, 0x00, 0x42, 0x03, 0x00, 0x00, 0x00, 0x7E, 0x39);

	-- �������� ��� ��� �� ������
	-- = string.char( 0x10, 0xFF, 0x90, 0x91, 0x00, 0x05, 0x00, 0x3F, 0x00, 0x00, 0x00, 0x00, 0xDE, 0x76);
	 
	-- 1 ������ ������ ���������
	-- local reqParamStr_1 = string.char( 0x10, 0xFF, 0x90, 0x01, 0x00, 0x1F, 0x00, 0x72, 0x4A, 0x03, 0x00, 0x07, 0x00, 0x4A, 0x03, 0x00, 0x06, 0x00, 0x4A, 0x03, 0x00, 0x40, 0x20, 0x4A, 0x03, 0x00, 0x42, 0x20, 0x4A, 0x03, 0x00, 0x03, 0x00, 0x4A, 0x03, 0x00, 0x04, 0x00, 0x19, 0x28);							 
	-- 2 ������ ������ ���������
	--local reqParamStr_2 = string.char( 0x10, 0xFF, 0x90, 0x02, 0x00, 0x0B, 0x00, 0x72, 0x4A, 0x03, 0x00, 0x01, 0x04, 0x4A, 0x03, 0x00, 0x00, 0x04, 0x1F, 0x0C);
	-- 3 ������ ������ ���������
	--local reqParamStr_3 = string.char( 0x10, 0xFF, 0x90, 0x03, 0x00, 0x06, 0x00, 0x72, 0x4A, 0x03, 0x00, 0x00, 0x00, 0xD2, 0xA7);

--[[--------------------------------------------------------------------------------------------------------------
	@brief				- ���������� �������� no ��� �� buf, ������� � ���� startbit
	@param	- buf		- ����� � �������
	@param	- startbit	- ������ ��� 
	@param	- no		- ���������� ���
--------------------------------------------------------------------------------------------------------------]]--
	local function extractBit(buf, startbit, no)
	  local mask = ~(-1 << no);
	  return (buf >> startbit) & mask;
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief	- �������������� ����� ������� 32 ��� IEEE 754 � ���������� �����
--------------------------------------------------------------------------------------------------------------]]--
	function ieee754Converter( hex)
		if hex >> 31 == 0 then
				sign = 1;
			else
				sign = -1;
		end
	  
		exponent = (hex >> 23)  & 0xFF;
	  
		if exponent ~= 0 then
				mantiss =  (hex & 0x7FFFFF) | 0x800000;
			else 
				mantiss = (hex & 0x7FFFFF) << 1;
		end
	  
		float = sign * (mantiss * 2^-23) * (2^(exponent-127));
	  
		return float;
	end
--[[--------------------------------------------------------------------------------------------------------------
	@brief						- �������� COM-�����
	@param	portName	string	- ��� �����
	@param	baudRate	number	- �������� ������
	@param	dataBits	number	- ���������� ��� ������
	@param	stopBits	number	- ���������� ����-���  
	@param	parity		string	- �������
--------------------------------------------------------------------------------------------------------------]]--
	function portOpen( portName, baudRate, dataBits, stopBits, parity)
		serialPort = SerialPort.open( portName, baudRate, dataBits, stopBits, parity);

		if serialPort == nil then
			Core.SPT943_Driver_Msg = "������ �������� ����� " .. "(" .. portName .. ")" .. "!";
			Core.addLogMsg( "portOpen: ������ �������� ����� " .. "(" .. portName .. ")" .. "!");
		return -1;
			else
				Core.SPT943_Driver_Msg = "���� ������ " .. "(" .. portName .. ")," .. " �������� ������ - " .. baudRate .. ".";
				Core.addLogMsg( "portOpen: ���� ������ " .. "(" .. portName .. ")," .. " �������� ������ - " .. baudRate .. ".");
		end	 
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief							- ������������� ������ �����
	@param	initSessionStr	string	- ������ ������������� ������ �����
--------------------------------------------------------------------------------------------------------------]]--
	function initSession( initSessionStr)
		serialPort:send( initSessionStr)
		--Core.addLogMsg( "initSession: ���������� " .. (string.len( initSessionStr)) .. " ����.");
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief					- ������ ������, ���� ������ (������), �������� ��������� �������� �������� ��������� ������ � ������
	@param	reqStr	string	- ������ ������ (������)
	@return	packet	table   - �������� ����� (������)
--------------------------------------------------------------------------------------------------------------]]--
	function reqResp( reqStr)

		local t1;					-- ����� ������ ������� ���������
		local respLen;				-- ������ �������� ������
		local respTimeout = 5;		-- ����� �������� ������ �� �������������
		local strPacket;			-- ����� �������� ��������
		local symTimeout = 0.01;	-- ������������� ����-���

		-- �������� �������
		serialPort:send( reqStr);
		--Core.addLogMsg( "reqResp: ���������� " .. ( string.len( reqStr)) .. " ����.");
		
		-- �������� ������ �� ��������� ������� respTimeout 
		t1 = os.clock();		-- ��������� �����

		while os.clock() - t1 <= respTimeout and serialPort:recvBytesAvailable() <= 0 do
			-- �������� ������� ��������� �������� ������  
		end
		
		respLen = serialPort:recvBytesAvailable();
		
		if	respLen <= 0 then
			Core.SPT943_Driver_Msg = "��� ������ �� �������������!";
			Core.addLogMsg( "reqResp: ��� ������ �� �������������!");
			return -1;
		end

		-- ������ �������-�� ����. �������� �� � ����� �� ������������ ������� symTimeout.
		strPacket = serialPort:recv( respLen);
		t1 = os.clock();							-- ��������� �����
		
		local packet = {};							-- ������ ��� �������� �������� ��������� ���������
	  
		while os.clock() - t1 <= symTimeout do		-- ���� �������� (t2-t1) <= symTimeout
			respLen = serialPort:recvBytesAvailable();
		-- ���� ������ ���������, �� ��������� �� � ����� � ���������� �����.

			if respLen > 0 then
				strPacket = strPacket .. serialPort:recv( respLen);
				t1 = os.clock();
			end
		end
		local b;
		for i = 1, (string.len( strPacket)) do
			b = string.byte( strPacket, i); 	-- �������� ��������� �������� �������
			table.insert( packet, b);			-- �������� ��������� �������� ������� � ���� �������
		end
		--Core.addLogMsg( "reqResp: �����: ������� " .. #packet .. " ����.");
		return packet;
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief					- �������� ����������� ����� cs
	@param	packet	table   - �������� ����� (������)
	@return -1				- ��� ������������ cs
	@return	packet	table   - ��� ���������� cs
--------------------------------------------------------------------------------------------------------------]]--
	function checkCS( packet)

	local printCsOk = "checkCS: OK!";
	local printCsErr = "checkCS: ������!";
	local printCalcCS = "checkCS: ����������� ����������� �����: ";
	local printRespCS = "checkCS: ����������� ����� � �������� ���������: ";
	local calcCS;												-- ����������� ����������� �����
	local respCS;												-- ����������� ����� � �������� ���������
	local lenPacket;											-- ����������� ������ ������

		lenPacket = #packet;						            -- ���������� ������� ������
		--Core.addLogMsg( "checkCS: ������� " .. lenPacket.. " ����.");

		if lenPacket == 9 then
			calcCS = 0;											-- ����������� ����� CS
			for i = 2,7 do
				calcCS = calcCS + packet[i];					-- �������������� �������� ������ 2..7
			end
			calcCS = calcCS & 0xFF;								-- �������� ������� ����
			calcCS = calcCS ~ 0xFF;								-- �������� ��������������
			--Core.addLogMsg( printCalcCS .. calcCS);

			respCS = packet[8];									-- ��������� 8-�� ���� (CS) �� ��������� ���������
			--Core.addLogMsg( printRespCS .. respCS);

				if calcCS ~= respCS then
					Core.addLogMsg( printCsErr);
					return -1;									-- ���������� ��� ������������ cs
					else
						--Core.addLogMsg( printCsOk);
						return packet;							-- ���������� ��� ���������� cs
				end
		end

		if lenPacket == 6 then
			calcCS = 0;											-- ����������� ����� CS
			for i = 2,4 do
				calcCS = calcCS + packet[i];					-- �������������� �������� ������ 2..4
			end
			calcCS = calcCS & 0xFF;								-- �������� ������� ����
			calcCS = calcCS ~ 0xFF;								-- �������� ��������������
			--Core.addLogMsg( printCalcCS .. calcCS);

			respCS = packet[5];									-- ��������� 5-�� ���� (CS) �� ��������� ���������
			--Core.addLogMsg( printRespCS .. respCS);

				if calcCS ~= respCS then
					Core.addLogMsg( printCsErr);
					return -1;									-- ���������� ��� ������������ cs
					else
						--Core.addLogMsg( printCsOk);
						return packet;							-- ���������� ��� ���������� cs
				end
		end

		if lenPacket == 8 then
			calcCS = 0;											-- ����������� ����� CS
			for i = 2,6 do
				calcCS = calcCS + packet[i];					-- �������������� �������� ������ 2..6
			end
			calcCS = calcCS & 0xFF;								-- �������� ������� ����
			calcCS = calcCS ~ 0xFF;								-- �������� ��������������
			--Core.addLogMsg( printCalcCS .. calcCS);

			respCS = packet[7];									-- ��������� 7-�� ���� (CS) �� ��������� ���������
			--Core.addLogMsg( printRespCS .. respCS);

	  if lenPacket ~= 6 and lenPacket ~= 8 and lenPacket ~= 9 then
		Core.addLogMsg( "checkCS: ������! ������ ������ �����������."); 
		return -1;
	  end

				if calcCS ~= respCS then
					Core.addLogMsg( printCsErr);
					return -1;									-- ���������� ��� ������������ cs
					else
						--Core.addLogMsg( printCsOk);
						return packet;							-- ���������� ��� ���������� cs
				end
		end	
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief					- �������� ������� ���� ������ 0x21 � �������� ���������
	@param	packet	table	- �������� �����
	@return -1				- ��� ������� ������	
	@return packet	table	- ��� ���������� ������
--------------------------------------------------------------------------------------------------------------]]--
	function checkError( packet)
			local fnc;			-- ��� �������
			local errorCode;	-- ��� ������

			fnc = packet[3];
			errorCode = packet[4];

			if  fnc == 0x21 then
					if errorCode == 0x00 then
							Core.SPT943_Driver_Msg = "������ (0x21), ��������� ��������� ������� (0x00).";
							Core.addLogMsg( "checkError: �����: ������ (0x21), ��������� ��������� ������� (0x00).");
							return -1;
						elseif errorCode == 0x01 then
							Core.SPT943_Driver_Msg = "������ (0x21), ������ �� ������ (0x01).";
							Core.addLogMsg( "checkError: �����: ������ (0x21), ������ �� ������ (0x01).");
							return -1;
						elseif errorCode == 0x02 then
							Core.SPT943_Driver_Msg = "������ (0x21), ������������ �������� ���������� ������� (0x02).";
							Core.addLogMsg( "checkError: �����: ������ (0x21), ������������ �������� ���������� ������� (0x02).");
							return -1;
					end
			end
				if fnc == 0x3F or fnc == 0x90 then
					--Core.addLogMsg( "checkError: ��!");
					return packet
				end 
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief					- �������� CRC � �������� ������
	@param packet	table	- �������� �����
	@return	-1				- ��� ������������ CRC
	@return	packet	table	- �������� �����
--------------------------------------------------------------------------------------------------------------]]--
	function checkCRC( packet)
		local printCRCOk = "checkCRC: OK!";
		local printCRCErr = "checkCRC: ������!";
		local printCalcCRC = "checkCRC: ����������� ����������� �����: ";
		local printRespCRC = "checkCRC: ����������� ����� � �������� ���������: ";
		local calcCRC;								-- ����������� CRC
		local respCRC;								-- CRC � �������� ���������
		local lenPacket;							-- ������ ������� � �������� ����������
		local cutPacket;							-- ���������� ����� ��� ������� CRC (��� ����� ������ ����� 0x10 � ���� ��������� ���� CRC)
		local lenCutPacket;							-- ������ ����������� �������
	  
		lenPacket = #packet;						-- ���������� ������� ������� � �������� ����������

	  -- ���������� ����������� ����� �� ��������� ��������� (������� � ������� CRC ���������� ������� �� ���� ������������ ����������)
	  local respCrcMSB = packet[ lenPacket - 1];	-- �������� crcL - ������� ���� CRC � ��������� �������� (������ �������)
	  local memCrcMSB = respCrcMSB;					-- ��������� crcL - ������� ���� CRC
	  local respCrcLSB = packet[ lenPacket];		-- �������� crcH - ������� ���� CRC � ��������� �������� (������ �������)
	  local memCrcLSB = respCrcLSB;					-- ��������� crcH - ������� ���� CRC
	  respCrcLSB = respCrcLSB << 8;					-- �������� ������� ���� CRC ����� �� 8 ���
	  respCRC = respCrcLSB | respCrcMSB;                  
	  --Core.addLogMsg( string.format( printRespCRC .. "%X", respCRC));

	  -- ������������ ���� ��������� ��������� (��� ����� ������ ����� 0x10 � ���� ��������� ���� CRC)
		table.remove( packet);			-- ������� ��������� ������� ������� (crcH - ������� ���� CRC)
		table.remove( packet);			-- ������� ��������� ������� ������� (crcL - ������� ���� CRC)
		table.remove( packet, 1);		-- ������� ������ �������� ������� (soh - ����������� ��� ������ ���������)
		lenCutPacket = #packet			-- ���������� ������� ����������� �������
		calcCRC = 0;
		local i = 1;
		while lenCutPacket > 0 do

	  -- ���������� CRC ���� ��������� ��������� (��� ����� ������ ����� 0x10 � ���� ��������� ���� CRC)
			calcCRC = calcCRC ~ packet[i] << 8;
			i = i + 1;
			for j = 0, 7 do
				if ( calcCRC & 0x8000) == 0x8000 then
					calcCRC = (( calcCRC << 1) ~ 0x1021) & 0xFFFF;
				else
					calcCRC = calcCRC << 1;
				end
			end
			lenCutPacket = lenCutPacket - 1;
		end
	  
	  -- ������ ������� ����� CRC
		local calcCrcLSB = extractBit( calcCRC, 0, 8);
		calcCrcLSB = calcCrcLSB << 8;
		local calcCrcMSB = extractBit( calcCRC, 8, 8);
		calcCRC = calcCrcLSB | calcCrcMSB;
		--Core.addLogMsg( string.format( printCalcCRC .. "%X", calcCRC));

		if calcCRC == respCRC then	
			--Core.addLogMsg( printCRCOk);
		table.insert ( packet, 1, 0x10);		-- �������� � ������� soh - ����������� ��� ������ ���������
		table.insert ( packet, memCrcMSB);		-- ��������	 � ������� crcL - ������� ���� CRC
		table.insert ( packet, memCrcLSB);		-- ��������	 � ������� crcH - ������� ���� CRC
		return packet;
		end
	  
		if calcCRC ~= respCRC then
			Core.addLogMsg( printCRCErr);
			return -1;
		end
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief						- ���������� CRC � ������ �������
	@param	tReqParam	table	- ������� � ��������������� ����������� �������� �������
	@return CRC					- ����������� CRC
--------------------------------------------------------------------------------------------------------------]]--
	function calcCRC( tReqParam)

	  local len =  #tReqParam;

	  local CRC = 0;
	  local i = 1;
	  while len > 0 do
		
		CRC = CRC ~ tReqParam[ i] << 8;
		i = i + 1;
		for J = 0, 7 do
		  if (CRC & 0x8000) == 0x8000 then
			CRC = ((CRC << 1) ~ 0x1021) & 0xFFFF;
		  else
			CRC = CRC << 1;
			
		  end
		end
		len = len - 1;
	  end
	--Core.addLogMsg("calcCRC: CRC: " .. CRC)
	return CRC;
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief	- ��������� ������ �������
--------------------------------------------------------------------------------------------------------------]]--
	function octetStringHandler()
		Core.addLogMsg( "octetStringHandler: ��������� ������ �������...");
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief	- ��������� ���������� ������
--------------------------------------------------------------------------------------------------------------]]--
	function nullHandler()
		Core.addLogMsg( "nullHandler: ��������� ���������� ������...");
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief	- ��������� ������ ASCII-��������
--------------------------------------------------------------------------------------------------------------]]--
	function ASCIIHandler()
		Core.addLogMsg( "ASCIIHandler: ��������� ASCII-��������...");
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief	- ��������� ���� �������� ������
--------------------------------------------------------------------------------------------------------------]]--
	function archdateHandler( packet, i, ch, c)

		local strH = "";	-- (Human) ������ ��� ������ � � �������� ����, ����������� ���������� �����.�����.��� ����:������ 
		local strE = "";	-- (Epoch) ������ ��� ������ � � �������� ���� � ������� EPOCH
		local n;			-- ���-�� ����, �������������� �����
		local t = {};		-- ������� ��� ��������� �������
	  
		Core.addLogMsg( "archdateHandler: ��������� ���� �������� ������...");

		n = packet[ i+1];	-- packet[ i+1] - 10-�� ���� ��������� - ���-�� ����, �������������� �����

		if n == 0x00 then	-- ������ ���������� ������� � ������						
			Core.addLogMsg( "archdateHandler: �����: � ������ ��������� ����������� ������.");
			return -1;
			elseif n == 0x02 and ch == 1 then	-- ����� - �����/��� ������������ 2 ������� -->> �������� ������
				-- strH = string.format("%02d.", packet[ i+3]) .. "20" .. packet[ i+2] .. "\n";	-- ������������ ������ ����: 09.2017
				-- if c < 5 then
					-- fdMonth_1:write( strH);													-- �������� ������ � ���� ������
				-- end
				respArchType = 3;
				-- �������� ����� � ������� EPOCH
				t.year = ("20" .. packet[ i+2]);	
				t.month = packet[ i+3];				
				strE = os.time(t) - 10800;			-- ������������ ������  � ������� EPOCH					
				if c < 5 then
					fdMonth_1:write( strE, "\n");	-- �������� ������ � ���� ������
				end

			elseif n == 0x02 and ch == 2 then	-- ����� - �����/��� ������������ 2 ������� -->> �������� ������
				-- strH = string.format("%02d.", packet[ i+3]) .. "20" .. packet[ i+2] .. "\n";	-- ������������ ������ ����: 09.2017
				-- if c < 5 then
					-- fdMonth_2:write( strH);													-- �������� ������ � ���� ������
				-- end
				respArchType = 3;
				-- �������� ����� � ������� EPOCH
				t.year = ("20" .. packet[ i+2]);	
				t.month = packet[ i+3];				
				strE = os.time(t) - 10800;			-- ������������ ������  � ������� EPOCH					
				if c < 5 then
					fdMonth_2:write( strE, "\n");	-- �������� ������ � ���� ������				
				end

			elseif n == 0x03 and ch == 1 then	-- ����� - �����/�����/��� ������������ 3 ������� -->> �������� ������
				-- strH = string.format("%02d.%02d.", packet[ i+4], packet[ i+3]) .. "20" .. packet[ i+2] ..	"\n";	-- ������������ ������ ����: 01.09.2017
				-- if c < 5 then
					-- fdDate_1:write( strH);																			-- �������� ������ � ���� ������
				-- end
				respArchType = 1;
				-- �������� ����� � ������� EPOCH
				t.year = ("20" .. packet[ i+2]);	
				t.month = packet[ i+3];				
				t.day = packet[ i+4];				
				t.hour = 0;							
				strE = os.time(t) - 10800;			-- ������������ ������  � ������� EPOCH					
				if c < 5 then
					fdDate_1:write( strE, "\n");	-- �������� ������ � ���� ������
				end

			elseif n == 0x03 and ch == 2 then	-- ����� - �����/�����/��� ������������ 3 ������� -->> �������� ������
				-- strH = string.format("%02d.%02d.", packet[ i+4], packet[ i+3]) .. "20" .. packet[ i+2] ..	"\n";	-- ������������ ������ ����: 01.09.2017
				-- if c < 5 then
					-- fdDate_2:write( strH);																			-- �������� ������ � ���� ������
				-- end
				respArchType = 1;
				-- �������� ����� � ������� EPOCH
				t.year = ("20" .. packet[ i+2]);	
				t.month = packet[ i+3];				
				t.day = packet[ i+4];				
				t.hour = 0;							
				strE = os.time(t) - 10800;			-- ������������ ������  � ������� EPOCH					
				if c < 5 then
					fdDate_2:write( strE, "\n");	-- �������� ������ � ���� ������
				end

			elseif n == 0x04 and ch == 1 then	-- ����� - �����/�����/��� ���� ������������ 4 ������� -->> ������� ������
				-- strH = string.format("%02d.%02d.", packet[ i+4], packet[ i+3]) .. "20" .. packet[ i+2] .. "\t" .. string.format("%02d:", packet[ i+5]) .. "00" .. "\n";	-- ������������ ������ ����: 01.09.2017 00:00
				-- if c < 5 then
					-- fdHour_1:write( strH);																													  				-- �������� ������ � ���� ������
				-- end
				respArchType = 0;
				-- �������� ����� � ������� EPOCH
				t.year = ("20" .. packet[ i+2]);	
				t.month = packet[ i+3];				
				t.day = packet[ i+4];				
				t.hour = packet[ i+5];				
				strE = os.time(t) - 10800;			-- ������������ ������  � ������� EPOCH					
				if c < 5 then
					fdHour_1:write( strE, "\n");	-- �������� ������ � ���� ������
				end

			elseif n == 0x04 and ch == 2 then	-- ����� - �����/�����/��� ���� ������������ 4 ������� -->> ������� ������
				-- strH = string.format("%02d.%02d.", packet[ i+4], packet[ i+3]) .. "20" .. packet[ i+2] .. "\t" .. string.format("%02d:", packet[ i+5]) .. "00" .. "\n";	-- ������������ ������ ����: 01.09.2017 00:00
				-- if c < 5 then
					-- fdHour_2:write(strH);																													  				-- �������� ������ � ���� ������
				-- end
				respArchType = 0;
				-- �������� ����� � ������� EPOCH
				t.year = ("20" .. packet[ i+2]);	
				t.month = packet[ i+3];				
				t.day = packet[ i+4];				
				t.hour = packet[ i+5];				
				strE = os.time(t) - 10800;			-- ������������ ������  � ������� EPOCH					
				if c < 5 then
					fdHour_2:write( strE, "\n");	-- �������� ������ � ���� ������
				end
		end
	local devTime = strE;
	return respArchType, devTime;
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief	- ��������� �������� �������
--------------------------------------------------------------------------------------------------------------]]--
	function timeHandler()
	  local strH = "";																	-- ������ � ������� ��������
	  strH = string.format("%02d:%02d:%02d", packet[ 20], packet[ 19], packet[ 18]);	-- ������������ ������ � ������� ��������
	  Core.addLogMsg( "dateHandler: �����: ������� �����: " .. strH);
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief	- ��������� ������� ����������� ����
--------------------------------------------------------------------------------------------------------------]]--
	function dateHandler( packet)

	  local tdw = { [0] = "�����������", 
					[1] = "�������",
					[2] = "�����",
					[3] = "�������",
					[4] = "�������",
					[5] = "�������",
					[6] = "�����������"};
	  
	  local strH = "";		-- ������ � ������� ����������� �����
	  local bdw;			-- ���� ��������� ���������� ���� ������
	  
	  bdw = packet[ 14];	-- �������� �������� ����� ���������� ���� ������
	  
	  for i = 0, 6 do
		if bdw == i then
		  bdw = tdw[ i];
		end
	  end
	  strH = string.format("%02d.%02d.", packet[ 11], packet[ 12]) .. "20" .. packet[ 13];	-- ������������ ������ � ������� ����������� �����
	  Core.addLogMsg( "dateHandler: �����: ������� ����: " .. strH .. ", " .. bdw);
	end

-- --[[--------------------------------------------------------------------------------------------------------------
	-- @brief	- ��������� ����� � ��������� ������ IEEE 754 (Float)
-- --------------------------------------------------------------------------------------------------------------]]--
	-- function IEEFloatHandler( packet, i, respArchType, ch)
		-- Core.addLogMsg( "IEEFloatHandler: ��������� ����� � ��������� ������ IEEE 754 (Float)...");
			-- local n;								-- ���������� ���� �������������� ������ �������� �������
			-- local str = "";							-- ������ � ������� �������� �������
			
				-- n = packet[ i+1];					-- �������� ���������� ���� �������������� ������ �������� �������
				-- for j = 1, n do
					-- str = str .. packet[ i+1+j];	-- ������������ ������ � ������� �������� �������
				-- end

			-- if respArchType == 3 and ch == 1 then			-- ����� - �����/��� ������������ 2 ������� -->> �������� ������
				-- fdMonth_1:write( str, "\n");				-- �������� ������ � ���� ��������� ������ ��������� ����� 1
				-- elseif respArchType == 3 and ch == 2 then
					-- fdMonth_2:write( str, "\n");			-- �������� ������ � ���� ��������� ������ ��������� ����� 2
				-- elseif respArchType == 1 and ch == 1 then	-- ����� - �����/�����/��� ������������ 3 ������� -->> �������� ������
					-- fdDate_1:write( str, "\n");				-- �������� ������ � ���� ��������� ������ ��������� ����� 1
				-- elseif respArchType == 1 and ch == 2 then
					-- fdDate_2:write( str, "\n");				-- �������� ������ � ���� ��������� ������ ��������� ����� 2
				-- elseif respArchType == 0 and ch == 1 then	-- ����� - �����/�����/��� ���� ������������ 4 ������� -->> ������� ������
					-- fdHour_1:write( str, "\n");				-- �������� ������ � ���� �������� ������ ��������� ����� 1
				-- elseif respArchType == 0 and ch == 2 then
					-- fdHour_2:write( str, "\n");				-- �������� ������ � ���� �������� ������ ��������� ����� 2
			-- end
	-- end

--[[--------------------------------------------------------------------------------------------------------------0x62312142
	@brief	- ��������� ����� � ��������� ������ IEEE 754 (Float)
--------------------------------------------------------------------------------------------------------------]]--
	function IEEFloatHandler( packet, i, respArchType, ch)
		Core.addLogMsg( "IEEFloatHandler: ��������� ����� � ��������� ������ IEEE 754 (Float)...");
		local hex;		-- ������ �������� ������� ��������� �� ������� (IEEE 754)
		local float;	-- ������ �������� ������� ��� ������ � ����� ������ (float)		

		local a = packet[ i+5];
		a = a << 24;
		local b = packet[ i+4];
		b = b << 16;
		local c = packet[ i+3];
		c = c << 8;
		local d = packet[ i+2];
		hex = a | b | c | d;

		float = ieee754Converter( hex);
		float = string.format( "%.3f", float );

		if respArchType == 3 and ch == 1 then			-- ����� - �����/��� ������������ 2 ������� -->> �������� ������
			fdMonth_1:write( float, "\n");				-- �������� ������ � ���� ��������� ������ ��������� ����� 1
			elseif respArchType == 3 and ch == 2 then
				fdMonth_2:write( float, "\n");			-- �������� ������ � ���� ��������� ������ ��������� ����� 2
			elseif respArchType == 1 and ch == 1 then	-- ����� - �����/�����/��� ������������ 3 ������� -->> �������� ������
				fdDate_1:write( float, "\n");			-- �������� ������ � ���� ��������� ������ ��������� ����� 1
			elseif respArchType == 1 and ch == 2 then
				fdDate_2:write( float, "\n");			-- �������� ������ � ���� ��������� ������ ��������� ����� 2
			elseif respArchType == 0 and ch == 1 then	-- ����� - �����/�����/��� ���� ������������ 4 ������� -->> ������� ������
				fdHour_1:write( float, "\n");			-- �������� ������ � ���� �������� ������ ��������� ����� 1
			elseif respArchType == 0 and ch == 2 then
				fdHour_2:write( float, "\n");			-- �������� ������ � ���� �������� ������ ��������� ����� 2
		end
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief		- ��������� �����
	@return	-1	- � ������ ����������� ������
	@return ret - ����� ������������ �������� (epoch)
--------------------------------------------------------------------------------------------------------------]]--
	function tagHandler( tag, packet, i, ch, c)
	
		local devTime;

		if tag == 0x04 then -- ������ �������													OCTET STRING
				octetStringHandler()
			elseif tag == 0x05 then -- ��� ������												NULL
				nullHandler();
			elseif tag == 0x16 then -- ������ ASCII-��������									ASCIIString
				ASCIIHandler();
			elseif tag == 0x41 then -- ����������� ����� (unsigned int)							IntU
				Core.addLogMsg( "tagHandler: ��������� ������������ ������...");
			elseif tag == 0x42 then -- ����� �� ������ (int)									IntS
				Core.addLogMsg( "tagHandler: ��������� ������ �� ������...");
			elseif tag == 0x43 then -- ����� � ��������� ������ IEEE 754 (Float)				IEEFloat
				IEEFloatHandler( packet, i, respArchType, ch);
			elseif tag == 0x44 then -- �������� � ��������������� ��������� (int + float)		MIXED
				Core.addLogMsg( "tagHandler: ��������� ��������� � ��������������� ��������� (int + float)...");
			elseif tag == 0x45 then -- ����������� �������� ����������� ��						Operative
				Core.addLogMsg( "tagHandler: ��������� ������������ ��������� ����������� ��...");
			elseif tag == 0x46 then -- �������������											ACK
				Core.addLogMsg( "tagHandler: ��������� �������������...");
			elseif tag == 0x47 then -- ������� �����											TIME
				timeHandler();
			elseif tag == 0x48 then -- ������� ����������� ����									DATE
				dateHandler( packet);
			elseif tag == 0x49 then -- ���� �������� ������										ARCHDATE
				local respArchType;
				respArchType, devTime = archdateHandler(  packet, i, ch, c);
			  if  respArchType == -1 then
				return -1;	-- � ������ ��������� ����������� ������  (0x49, 0x00)
			  end
			elseif tag == 0x4A then -- ����� ���������											PNUM
				Core.addLogMsg( "tagHandler: ��������� ������ ���������...");
			elseif tag == 0x4B then -- ������ ������											FLAGS
				Core.addLogMsg( "tagHandler: ��������� ������ ������...");
			elseif tag == 0x55 then -- ������													ERR
				Core.addLogMsg( "tagHandler: ��������� ������...");
		end
		return devTime;
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief			- ��������� �������� ���������
	@param	packet	- �������� �����
	@return -1		- ������ �������� COM-�����
--------------------------------------------------------------------------------------------------------------]]--
	function packetHandler( packet, ch)

		local deviceCode = "";	-- ��� ����������
		local fnc;				-- ��� �������
		local byte3;			-- � ����������� �� ������� (����������� ��� �������) ���������: FRM � ��� ������� ��������� ��� FNC - ��� �������
		local tag;				-- ���
		local dl = 0;			-- ������ ����������� ��������� ������
		local lenL;				-- ������ ���� ��������� (��. ����)
		local lenH;				-- ������ ���� ��������� (��. ����)
		local lenMsgBody;		-- ������ ���� ���������
		local i = 9;			-- ���������� ����� ���� ���� �������� ������ 0x49
		local devTime;			-- ����� ������������ �������� 
	--
	--		0x3F ��������� ������ �� ������ ������������� ������ (�����٨���� �����)
	--

		local byte3 = packet[ 3];	-- ����������� ������� ���� ������� ��������� --> 0x90 � 3-�� ����� ������ (� ����������� ������� frm �� ����� 0x90 )

		if byte3 == 0x3F then		-- ��������� ������ �� ������ ������ ����� (����������� ������)
			for i = 4, 5 do
				deviceCode = deviceCode .. " " .. string.format("%.2X", packet[ i]);
			end
			Core.SPT943_Driver_Msg = "��� ����������: " .. deviceCode .. "," .. " ������������� ����������: " .. string.format("%.2X", packet[ 6]) .. ".";
			Core.addLogMsg( "packetHandler: �����: ��� ����������: " .. deviceCode .. "," .. " ������������� ����������: " .. string.format("%.2X", packet[ 6]) .. ".");
			--goto finish;
			return;
		end


		if byte3 == 0x90 then		-- ������ ��������� - �������
	--
	--		0x3F ��������� ������ �� ������ ������������� ������ (������� �����)
	--

			fnc = packet[ 8];		-- ����������� ���� ������� � 8-�� ����� ������

			if fnc == 0x3F then
				for i = 9, 10 do
					deviceCode = deviceCode .. " " .. string.format("%.2X", packet[ i]);
				end
				Core.SPT943_Driver_Msg = "��� ����������: " .. deviceCode .. "," .. " ������������� ����������: " .. string.format("%.2X", packet[ 11]) .. ".";
				Core.addLogMsg( "packetHandler: �����: ��� ����������: " .. deviceCode .. "," .. " ������������� ����������: " .. string.format("%.2X", packet[ 11]) .. ".");
				--goto finish;
				return;
			end

	--
	--		0x42 ��������� ������ �� ������ ��������� �������� ������	 (������� �����)
	--

			if fnc == 0x42 then
				Core.SPT943_Driver_Msg = "�������� ������ ������������� - 19200.";
				Core.addLogMsg( "packetHandler: �����: �������� ������ ������������� - 19200.");
				serialPort:clearBuffers( );		-- �������� ������� � ���������� �����
				serialPort:close();				-- ���������� ������
				os.sleep(1)
				-- �������� COM-����� �� �������� 19200
				local baudRate = 19200;		-- �������� ������
				Core.SPT943_Driver_Msg = "�������� " .. portName .. " �� �������� " ..baudRate .. "...";
				Core.addLogMsg( "portOpen: �������� COM-����� (19200)...");
				local ret = portOpen( portName, baudRate, dataBits, stopBits, parity);
				if  ret == -1 then				  
				  return -1;												-- ������ �������� ����� ==>> ����� �� ���������
				end
				return;
			end

	--
	--		0x72 ��������� ������ �� ������ ������ ��������� (������� �����)
	--

			if fnc == 0x72 then

				-- ���������� �������� ������� ���� ���������:

				lenL = packet[ 6];						-- �������� �������� ������� ���� ��������� (��. ����)
				lenH = packet[ 7];						-- �������� �������� ������� ���� ��������� (��. ����)
				lenH = lenH << 8;
				lenMsgBody = lenL | lenH;				-- �������� �������� ������� ���� ���������
				lenMsgBody = lenMsgBody + 4;			-- ������ ���� ��������� ��������� �� 1 (���� fnc) ��� ��������� �����

				-- ���� ��������� �������� ����� �������� ����������� ��������� ������ � ��������� ������:

				while lenMsgBody > 0 do
					tag = packet[ i];					-- �������� �������� ���� � i-�� ����� ������
					dl = packet[ i+1];					-- �������� ������ ����������� ��������� ������ � i+1-�� ����� ������

					tagHandler( tag, packet, i, ch, c)		-- ��������� �����

					i = i + dl + 2;						-- �������� ��������� ����� �����
					dl = 2 + dl;
					lenMsgBody = lenMsgBody - dl;		-- ��������� ������� ���� ���������� ���������
				end
			end

	--
	--		0x61 ��������� ������ �� ������ ������ �������� ������ (������� �����)
	--

			if fnc == 0x61 then

				local c = 0; 	-- ������� ������� ��������� ���� �������� ������
								-- ��������� ������ ������� � �������� ���� � ������ ����� ������  
	::up::
				while (1) do
					tag = packet[ i];					-- �������� �������� ���� � i-�� ����� ������
					if tag ~= 0x30 then					-- ��� �� �������� ����� ������������������
						dl = packet[ i+1];				-- �������� ������ ����������� ��������� ������ � i+1-�� ����� ������
					
						if tag == 0x49 then
							c = c + 1;
						end 

						local ret = tagHandler( tag, packet, i, ch, c);	-- ��������� �����
						devTime = ret;			-- 

						if ret == -1 then					-- � ������ ��������� ����������� ������ (0x49, 0x00)
						  	return;
						end
			
						i = i + dl + 2;						-- �������� ��������� ���������� ����� �����
		
					end

					if tag == 0x30 then						-- ��� �������� ����� ������������������
						local quantity;
						local dl;
						local msb;							-- ���� ���� ������������������ ����� �������� & � 1000 0000

						if devTime and packet[ i+1] == 0x00 then
							Core.addLogMsg( "packetHandler: �����: ����� �������� ������.");
							goto finish;							-- ����� �������� ������ (0x49, 0xXY, 0x30, 0x00)
						end
						
						msb = packet[ i+1] & 0x80;						-- �������� �������� ���� �� "1"								

						if msb == 0x80 then								-- ���� ������� ��� == "1" ( ��������� ������ �����������)
							quantity = extractBit( packet[ i+1], 0, 7);	-- ��������� ��������� ������� ������������ ����� ����������� ��������� ������ (����1 ... ����N)
							dl = 1 + 1 + quantity ;						-- �������� ������ � ������: ���� ������������������ (0x30) + ������� ���� + (����1 ... ����N)
						end

						if msb ~= 0x80 then								-- ���� ������� ��� == "0" ( ������� ������ �����������)
							quantity = 0;								-- ���������� ���� ������������ ����� ����������� ��������� ������ � ������������������ = 0
							dl = 2;										-- �������� ������ � ������: ���� ������������������ (0x30) + ������� ����
						end

						-- ������� ����� � ������������ ������ �� ���������� ������ � ������� �������� �������	(������ 0 .. 15)
						for a = 1, 16 do
							i = i + dl;									-- �������� ���������� ����� ��������� ������������� ������
							dl = packet[ i+1]							-- �������� ���������� ���� ������� ��������� ������������� ������
							dl = dl + 2;								-- �������� ���������� ����: ���� ����� + ���������� ������ ������ + ���� ����
											  
							if a == 16 then								-- �������� ������ 15 � ������ ������������� ������ � ������� �������� �������
								IEEFloatHandler( packet, i, respArchType, ch)	-- ��������� ������ � ������� �������� �������
		 
								-- ������� ����� � ������������ ������ �� ���������� ��������� ������ ������ ������������� ������ (������ 16 .. 26)
								for b = 1, 11 do
									i = i + dl;							-- �������� ���������� ����� ��������� ������������� ������
									dl = packet[ i+1]					-- �������� ���������� ���� ������� ��������� ������������� ������
									dl = dl + 2;						-- �������� ���������� ����: ���� ����� + ���������� ������ ������ + ���� ����	
								  
									if b == 11 then						-- �������� ��������� 26-�� ������ � ������ ������������� ������
									  goto up;
									end
								end
							end
						end
						i = i + dl;						-- �������� ��������� ���������� ����� �����
					end
				end
			end
		end
	::finish::
	return devTime; -- ����� ������������ ��������
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief				- ���������� ������ ��� ������� �������� �������
	@param id			- ����������� ���������										- ��������� "������ ����������"
	@param ch			- ����� ������												- ��������� "������ ����������"
	@param rectype		- ��� ������������� ������� (�������, ��������, ��������)	- ��������� "������ ����������"
	@param StartDate	- ��������� ���� ������										- ��������� "������ ����������"
	@param endDate		- �������� ���� ������										- ��������� "������ ����������"
	@return packet		- ����� ������� � ��������
--------------------------------------------------------------------------------------------------------------]]--
	function preparePacketReqArchive( id, ch, rectype, StartDate, endDate)
	  
	  local tHourDate = {};					  -- ������� � ��������������� ����������� �������� ������� � �������� ������� 
	  local tMonth = {};					  -- ������� � ��������������� ����������� �������� �������� �������
	  local packet = "";					  -- ������ ������� �������������� � ��������
	  local len_tHourDate;					  -- ������ ������� � ��������������� ����������� �������� ������� � �������� �������
	  local len_tMonth;						  -- ������ ������� � ����������� ����������� �������� �������� �������
	  
	  -- ���������� ������� tHourDate:
	  
	  local dateTable;						  -- ��������� �������, ��� �������� ���� � �������
	  local temp;							  -- ��������� ����������
--------- ������ ��������/��������� ������ --------------------------------------------------------------------------------------------
	  if rectype == 0 or rectype == 1 then	  
		
		dateTable = os.date( "*t", StartDate);  -- ��������� ��������� ������� ��������� ��������� ����

		temp = tostring( dateTable.year);	   -- �������� ������ "2017"
		temp = string.sub ( temp, 3);		   -- �������� ������ "17"
		temp = tonumber( temp);					-- �������� ����� 17 

		local startYY = temp;				   -- �������� ��� (������)
		local startMH = dateTable.month;	   -- �������� ����� (������)
		local startDD = dateTable.day;		   -- �������� ����� (������)
		local startHH = dateTable.hour;		   -- �������� ��� (������)	   

		dateTable = os.date( "*t", endDate);	   -- ��������� ��������� ������� ��������� �������� ����

		temp = tostring( dateTable.year);	   -- �������� ������ "2017"
		temp = string.sub ( temp, 3);		   -- �������� ������ "17"
		temp = tonumber( temp);				   -- �������� ����� 17 

		local endYY = temp;					   -- �������� ��� (�����)
		local endMH = dateTable.month;		   -- �������� ����� (�����)
		local endDD = dateTable.day;			   -- �������� ����� (�����)
		local endHH = dateTable.hour		   -- �������� ��� (�����)	  

		tHourDate[1] = 0x10;	   -- soh						����������� ��� ������ ���������, ������ 0x10
		tHourDate[2] = 0xFF;	   -- nt						������� ����� ��������-��������, 0xFF - ����������� ��������� � ��������
		tHourDate[3] = 0x90;	   -- frm						��� ������� ���������
		tHourDate[4] = id;		   -- id			�������	����������� ���������
		tHourDate[5] = 0x00;	   -- atr						��������������� (0x00)
		tHourDate[6] = 0x1C;	   -- lenL						����� ���� ���������, ������� ����
		tHourDate[7] = 0x00;	   -- lenH						����� ���� ���������, ������� ����
		tHourDate[8] = 0x61;	   -- func						��� ������� ������ �������� ������, ������ 0x61
		tHourDate[9] = 0x04;	   -- octetStringTag			��� ������ �������
		tHourDate[10] = 0x05;	   -- dl_1						����� ����������� ��������� ������
		tHourDate[11] = 0xFF;	   -- noL						����� ��������� �������, ������� ����
		tHourDate[12] = 0xFF;	   -- noH						����� ��������� �������, ������� ����
		tHourDate[13] = ch;		   -- ch			�������	����� ������  (1 ��� 2)
		tHourDate[14] = rectype;   -- rectype		�������	���������� ��� ������������� ������� � ������ �� ������
		tHourDate[15] = 0x50;	   -- n							������������ ���������� ���������� � ����� �������
		tHourDate[16] = 0x49;	   -- archDateTag				��� ���� �������� ������
		tHourDate[17] = 0x08;	   -- dl_2						����� ����������� ��������� ������
		tHourDate[18] = startYY;   -- yy			�������	��� ������������ ������ ����������� (������)
		tHourDate[19] = startMH;   -- mh			�������	����� (������)
		tHourDate[20] = startDD;   -- dd			�������	���� (������)
		tHourDate[21] = startHH;   -- hh			�������	��� (������)
		tHourDate[22] = 0x00;	   -- mm						������ (������)
		tHourDate[23] = 0x00;	   -- ss						������� (������)
		tHourDate[24] = 0x00;	   -- ms_l						������������, ������� ���� (������)
		tHourDate[25] = 0x00;	   -- ms_h						������������, ������� ���� (������)
		tHourDate[26] = 0x49;	   -- archDateTag				��� ���� �������� ������
		tHourDate[27] = 0x08;	   -- dl_3						����� ����������� ��������� ������
		tHourDate[28] = endYY;	   -- yy			�������	��� ������������ ������ ����������� (�����)
		tHourDate[29] = endMH;	   -- mh			�������	����� (�����)
		tHourDate[30] = endDD;	   -- dd			�������	���� (�����)
		tHourDate[31] = endHH;	   -- hh			�������	��� (�����)
		tHourDate[32] = 0x00;	   -- mm						������ (�����)
		tHourDate[33] = 0x00;	   -- ss						������� (�����)
		tHourDate[34] = 0x00;	   -- ms_l						������������, ������� ���� (�����)
		tHourDate[35] = 0x00;	   -- ms_h						������������, ������� ���� (�����)
		tHourDate[36] = 0x00;	   -- crcL		�����������		CRC16, ������� ����
		tHourDate[37] = 0x00;	   -- crcH		�����������		CRC16, ������� ����	 

		table.remove( tHourDate);			-- ������� ��������� ������� ������� (crcH - ������� ���� CRC)
		table.remove( tHourDate);			-- ������� ��������� ������� ������� (crcL - ������� ���� CRC)
		table.remove( tHourDate, 1);		-- ������� ������ �������� ������� (soh - ����������� ��� ������ ���������)
	 
		local CRC = calcCRC( tHourDate);	-- ��������� CRC
		
		local crcL = CRC >> 8;				-- �������� crcH - ������� ���� CRC
		local crcH = CRC & 0xFF;			-- �������� crcL - ������� ���� CRC
		table.insert ( tHourDate, 1, 0x10);	-- �������� � ������� soh - ����������� ��� ������ ���������
		table.insert ( tHourDate, crcL);		-- ��������	 � ������� crcL - ������� ���� CRC
		table.insert ( tHourDate, crcH);		-- ��������	 � ������� crcH - ������� ���� CRC
		
		-- ������������ ������ ������� �������� ������ ��� �������� � COM-����:

		len_tHourDate = #tHourDate;
		for i = 1, len_tHourDate do
		  packet = packet .. string.char( tHourDate[ i]);
		end

--------- ������ ��������� ������ --------------------------------------------------------------------------------------------
 		  elseif rectype == 3 then
		  -- 10 FF 90 04 00 10 00 61 04 05 FF FF 01 03 50 49 02 11 01 49 02 11 09 31 D0

			-- ���������� ������� tMonth:

			dateTable = os.date( "*t", StartDate);	-- ��������� ��������� ������� ��������� ��������� ���� 

			temp = tostring( dateTable.year);		-- �������� ������ "2017"
			temp = string.sub ( temp, 3);			-- �������� ������ "17"
			temp = tonumber( temp);					-- �������� ����� 17 

			startYY = temp;							-- �������� ��� (������)
			startMH = dateTable.month;				-- �������� ����� (������)

			dateTable = os.date( "*t", endDate);		-- ��������� ��������� ������� ��������� �������� ����

			temp = tostring( dateTable.year);		-- �������� ������ "2017"
			temp = string.sub ( temp, 3);			-- �������� ������ "17"
			temp = tonumber( temp);					-- �������� ����� 17

			endYY = temp;							-- �������� ��� (�����)
			endMH = dateTable.month;				-- �������� ����� (�����)
			 
			tMonth[1] = 0x10;		  -- soh						����������� ��� ������ ���������, ������ 0x10
			tMonth[2] = 0xFF;		  -- nt							������� ����� ��������-��������, 0xFF - ����������� ��������� � ��������
			tMonth[3] = 0x90;		  -- frm						��� ������� ���������
			tMonth[4] = id;			  -- id				�������	����������� ���������
			tMonth[5] = 0x00;		  -- atr						��������������� (0x00)
			tMonth[6] = 0x10;		  -- lenL						����� ���� ���������, ������� ����
			tMonth[7] = 0x00;		  -- lenH						����� ���� ���������, ������� ����
			tMonth[8] = 0x61;		  -- func						��� ������� ������ �������� ������, ������ 0x61
			tMonth[9] = 0x04;		  -- octetStringTag				��� ������ �������
			tMonth[10] = 0x05;		  -- dl_1						����� ����������� ��������� ������
			tMonth[11] = 0xFF;		  -- noL						����� ��������� �������, ������� ����
			tMonth[12] = 0xFF;		  -- noH						����� ��������� �������, ������� ����
			tMonth[13] = ch;		  -- ch							����� ������
			tMonth[14] = 0x03;		  -- rectype					���������� ��� ������������� ������� � ������ �� ������	 (3 - ��������)
			tMonth[15] = 0x50;		  -- n							������������ ���������� ���������� � ����� �������
			tMonth[16] = 0x49;		  -- archDateTag				��� ���� �������� ������
			tMonth[17] = 0x02;		  -- dl_2						����� ����������� ��������� ������
			tMonth[18] = startYY;	  -- yy				�������	��� ������������ ������ �����������
			tMonth[19] = startMH;	  -- mh				�������	�����
			tMonth[20] = 0x49;		  -- archDateTag				��� ���� �������� ������
			tMonth[21] = 0x02;		  -- dl_3						����� ����������� ��������� ������
			tMonth[22] = endYY;		  -- yy				�������	��� ������������ ������ �����������
			tMonth[23] = endMH;		  -- mh				�������	�����
			tMonth[24] = 0x00;		  -- crcL		�����������		CRC16, ������� ����
			tMonth[25] = 0x00;		  -- crcH		�����������		CRC16, ������� ����
				  
			table.remove( tMonth);		-- ������� ��������� ������� ������� (crcH - ������� ���� CRC)
			table.remove( tMonth);		-- ������� ��������� ������� ������� (crcL - ������� ���� CRC)
			table.remove( tMonth, 1);	-- ������� ������ �������� ������� (soh - ����������� ��� ������ ���������)			
			
			local CRC = calcCRC( tMonth);		-- ��������� CRC
			
			local crcL = CRC >> 8;				-- �������� crcH - ������� ���� CRC
			local crcH = CRC & 0xFF;			-- �������� crcL - ������� ���� CRC
			table.insert (tMonth, 1, 0x10);		-- �������� � ������� soh - ����������� ��� ������ ���������
			table.insert (tMonth, crcL);		-- ��������  � ������� crcL - ������� ���� CRC
			table.insert (tMonth, crcH);		-- ��������  � ������� crcH - ������� ���� CRC			   
			  
			  -- ������������ ������ ������� �������� ������ ��� �������� � COM-����:
			  len_tMonth = #tMonth;
			  for i = 1, len_tMonth do
				packet = packet .. string.char( tMonth[ i]);
			  end
	  end
	return packet;
	end

--[[--------------------------------------------------------------------------------------------------------------
	@brief						- ���� ��� ���������� id (0..255), ������� ch (1/2), ������� rectype (0,1,3), StartDate � endDate
	@param	userArchTypeHour	- ��� ������ �������� ������������� - �������
	@param	userArchTypeDate	- ��� ������ �������� ������������� - ��������
	@param	userArchTypeMonth	- ��� ������ �������� ������������� - ��������
	@param	userStartDate		- ��������� ���� �������� �������������
	@param	userEndDate			- �������� ���� �������� �������������
--------------------------------------------------------------------------------------------------------------]]--
	function bu( userArchTypeHour, userArchTypeDate, userArchTypeMonth, userStartDate, userEndDate)

		local id = 1;				-- ����������� ���������
		local ch = 1;				-- ����� ������
		local rectype;				-- ��� ������
		local StartDate;			-- ��������� ����
		local endDate;				-- �������� ����
		local ret;					-- ������������ �������� �������
		local packet;				-- �����
		local c = 1;				-- ������� �������
		local tryConnection = 3;	-- ���������� ����������� (��������) � �������������
		local devTime;

		if (userArchTypeHour == 0 and userArchTypeDate == 0 and userArchTypeMonth == 0) or (userArchTypeHour == nil and userArchTypeDate == nil and userArchTypeMonth == nil) then
			Core.SPT943_Driver_Msg = "��������! �� ������ ���� �������� �������.";
			Core.addLogMsg( "bu: " .. "��������! �� ������ ���� �������� �������.");
			return -1;
		end

		if userStartDate == nil or userEndDate == nil then
			Core.SPT943_Driver_Msg = "��������! �� ������ ��������� �/��� �������� ���� �������� �������.";
			Core.addLogMsg( "bu: " .. "��������! �� ������ ��������� �/��� �������� ���� �������� �������.");
			return -1;
		end
--------------------------------------------------------------------------------------
		if userArchTypeHour == true then -- ����� ��� �������� ������
			
			rectype = 0;
			StartDate = userStartDate;
			endDate = userEndDate;
			Core.SPT943_Driver_Msg = "������ �������� ������ � " .. os.date( "%d.%m.%Y %H:%M", StartDate) .. " �� " .. os.date( "%d.%m.%Y %H:%M", endDate) .. "...";
			Core.addLogMsg( "bu: " .. "������ �������� ������ � " .. os.date( "%d.%m.%Y %H:%M", StartDate) .. " �� " .. os.date( "%d.%m.%Y %H:%M", endDate) .. "...");
			
			fdHour_1 = io.open( pathHour_1, "a+");								-- ������� ���� �������� ������ ��1 �� ��������
			if fdHour_1 == nil then												-- �������� �������� ����� �������� ������ ��1
				Core.SPT943_Driver_Msg = "������ �������� ����� �������� ������ ��1!";
				Core.addLogMsg( "bu: ������ �������� ����� �������� ������ ��1!");
				return -1;
			end

			fdHour_1:setvbuf( "full", 1024);                       				-- ������ ����� ����� - ������ �����������

			fdHour_2 = io.open( pathHour_2, "a+");								-- ������� ���� �������� ������ ��2 �� ��������
			if fdHour_2 == nil then												-- �������� �������� ����� �������� ������ ��2
				Core.SPT943_Driver_Msg = "������ �������� ����� �������� ������ ��2!";
				Core.addLogMsg( "bu: ������ �������� ����� �������� ������ ��2!");
				return -1;
			end

			fdHour_2:setvbuf( "full", 1024);                       				-- ������ ����� ����� - ������ �����������			
--------------------------------------------------------------------------------------			
			while 1 do
				Core.addLogMsg( "bu: ch: " .. ch);
				Core.addLogMsg( "bu: id: " .. id);
				Core.addLogMsg( "bu: " .. os.date("%d.%m.%Y %H:%M", StartDate));
--[[----------------------------------------------------------------------------------
	���������� ������ ��� ������� �������� ������� �������� ������ ��1
----------------------------------------------------------------------------------]]--
				ret = preparePacketReqArchive( id, ch, rectype, StartDate, endDate);
				packet = ret;
--[[----------------------------------------------------------------------------------
	������ �������� ������� �������� ������ ��1
----------------------------------------------------------------------------------]]--
::rrH::     
				ret = reqResp( packet);
				if ret == -1 then
					Core.SPT943_Driver_Msg = "������ �������� ������ ��1, ������� " .. c .. " �� " .. tryConnection .. "..."
					Core.addLogMsg( "bu: ������ �������� ������ ��1, ������� " .. c .. " �� " .. tryConnection .. "...");
					c = c + 1;
					if c <= 3 then
					os.sleep( 1);
					goto rrH;															-- ��� ������ �� ������������� ==>> ������ ������� 
							else 
							Core.SPT943_Driver_Msg = "����� �������� �������� ������ ��1 ��������!"
							Core.addLogMsg( "bu: ����� �������� �������� ������ ��1 ��������!");	-->> ����� �� ���������
							return -1;
						end
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� CRC
----------------------------------------------------------------------------------]]-- 
				ret = checkCRC( packet);
				if ret == -1 then
				  goto rrH;																		-- CRC �� ������� ==>> ������ �������
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� ������� ���� ������ (0x21) � �������� ���������
----------------------------------------------------------------------------------]]--
				ret = checkError( packet);
				if ret == -1 then
				  goto rrH;																		-- � ������ ������������ ��� ������ (0x21) ==>> ������ �������
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	��������� ������� �������� ������ ��1
----------------------------------------------------------------------------------]]--
				devTime = packetHandler( packet, ch);
--------------------------------------------------------------------------------------
				id = id + 1;		-- ��������� �� 1 ����������� ���������
				if id == 256 then	-- ��� ������������ �������� id
					id = 0;
				end
--------------------------------------------------------------------------------------
				if ch == 1 then		-- ������ ������ ������ (1/2)
					ch = 2;
					elseif ch == 2 then
						ch = 1;
				end
--------------------------------------------------------------------------------------
				Core.addLogMsg( "bu: ch: " .. ch);
				Core.addLogMsg( "bu: id: " .. id);
				Core.addLogMsg( "bu: " .. os.date("%d.%m.%Y %H:%M", StartDate));
--[[----------------------------------------------------------------------------------
	���������� ������ ��� ������� �������� ������� �������� ������ ��2
----------------------------------------------------------------------------------]]--
				ret = preparePacketReqArchive( id, ch, rectype, StartDate, endDate);
				packet = ret;
--[[----------------------------------------------------------------------------------
	������ �������� ������� �������� ������ ��2
----------------------------------------------------------------------------------]]--
::rrH1::     
				ret = reqResp( packet);
				if ret == -1 then
					Core.SPT943_Driver_Msg = "������ �������� ������ ��2, ������� " .. c .. " �� " .. tryConnection .. "...";
					Core.addLogMsg( "bu: ������ �������� ������ ��2, ������� " .. c .. " �� " .. tryConnection .. "...");
					c = c + 1;
					if c <= 3 then
					os.sleep( 1);
					goto rrH1;															-- ��� ������ �� ������������� ==>> ������ ������� 
							else 
							Core.SPT943_Driver_Msg = "����� �������� �������� ������ ��2 ��������!";
							Core.addLogMsg( "bu: ����� �������� �������� ������ ��2 ��������!");	-->> ����� �� ���������
							return -1;
						end
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� CRC
----------------------------------------------------------------------------------]]-- 
				ret = checkCRC( packet);
				if ret == -1 then
				  goto rrH1;																		-- CRC �� ������� ==>> ������ �������
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� ������� ���� ������ (0x21) � �������� ���������
----------------------------------------------------------------------------------]]--
				ret = checkError( packet);
				if ret == -1 then
				  goto rrH1;																		-- � ������ ������������ ��� ������ (0x21) ==>> ������ �������
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	��������� ������� �������� ������ ��2
----------------------------------------------------------------------------------]]--
				devTime = packetHandler( packet, ch);
				if devTime == nil or devTime >= endDate then
					Core.addLogMsg( "bu: ��������� ������� �������� ������ ��1, ����� ���������� � ����: " .. tostring(devTime));
					fdHour_1:flush();				-- �������� �������� ����� ����� �� ����
					fdHour_1:close();				-- ������� ���������� �����
					fdHour_2:flush();				-- �������� �������� ����� ����� �� ����
					fdHour_2:close();				-- ������� ���������� �����
					break;
				end
--------------------------------------------------------------------------------------				
				id = id + 1;		-- ��������� �� 1 ����������� ���������
				if id == 256 then	-- ��� ������������ �������� id
					id = 0;
				end
--------------------------------------------------------------------------------------
				if ch == 1 then		-- ������ ������ ������ (1/2)
					ch = 2;
					elseif ch == 2 then
						ch = 1;
				end
--------------------------------------------------------------------------------------
				StartDate = devTime;
--------------------------------------------------------------------------------------
				if StartDate >= endDate then	-- ���� ��������� ���� ���������� � �������� ����� �������� ����
					Core.SPT943_Driver_Msg = "������ �������� ������ ���������.";
					Core.addLogMsg( "bu: " .. "������ �������� ������ ���������.");
					fdHour_1:flush();				-- �������� �������� ����� ����� �� ����
					fdHour_1:close();				-- ������� ���������� �����
					fdHour_2:flush();				-- �������� �������� ����� ����� �� ����
					fdHour_2:close();				-- ������� ���������� �����
					break;
				end
			end
		end
--------------------------------------------------------------------------------------
		if userArchTypeDate == true then -- ����� ��� ��������� ������

			rectype = 1;
			StartDate = userStartDate;
			endDate = userEndDate;
			Core.SPT943_Driver_Msg = 
			Core.addLogMsg( "bu: " .. "������ ��������� ������ ��1 � " .. os.date( "%d.%m.%Y %H:%M", StartDate) .. " �� " .. os.date( "%d.%m.%Y %H:%M", endDate) .. "...");

			fdDate_1 = io.open( pathDate_1, "a+");									-- ������� ���� ��������� ������ ��1 �� ��������
			if fdDate_1 == nil then													-- �������� �������� ����� ��������� ������ ��1
				Core.SPT943_Driver_Msg = 
				Core.addLogMsg( "bu: ������ �������� ����� ��������� ������ ��1!");
				return -1;
			end

			fdDate_1:setvbuf( "full", 1024);                       					-- ������ ����� ����� - ������ �����������	

			fdDate_2 = io.open( pathDate_2, "a+");									-- ������� ���� ��������� ������ ��2 �� ��������
			if fdDate_2 == nil then													-- �������� �������� ����� ��������� ������ ��2
				Core.SPT943_Driver_Msg = 
				Core.addLogMsg( "bu: ������ �������� ����� ��������� ������ ��2!");
				return -1;
			end

			fdDate_2:setvbuf( "full", 1024);                       					-- ������ ����� ����� - ������ �����������			
--------------------------------------------------------------------------------------			
			while 1 do
				Core.addLogMsg( "bu: ch: " .. ch);
				Core.addLogMsg( "bu: id: " .. id);
				Core.addLogMsg( "bu: " .. os.date("%d.%m.%Y %H:%M", StartDate));
--[[----------------------------------------------------------------------------------
	���������� ������ ��� ������� �������� ������� ��������� ������ ��1
----------------------------------------------------------------------------------]]--
				ret = preparePacketReqArchive( id, ch, rectype, StartDate, endDate);
				packet = ret;
--[[----------------------------------------------------------------------------------
	������ �������� ������� ��������� ������ ��1
----------------------------------------------------------------------------------]]--
::rrD::     
				ret = reqResp( packet);
				if ret == -1 then				 	  
					c = c + 1;
					Core.SPT943_Driver_Msg = 
					Core.addLogMsg( "bu: ������ ��������� ������ ��1, ������� " .. c .. " �� " .. tryConnection .. "...");
						if c <= 3 then										 
							os.sleep( 1);
							goto rrD;								-- ��� ������ �� ������������� ==>> ������ ������� 
							else 
							Core.addLogMsg( "bu: ����� �������� ��������� ������ ��1 ��������!");	-->> ����� �� ���������
							return -1;
						end
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� CRC
----------------------------------------------------------------------------------]]-- 
				ret = checkCRC( packet);
				if ret == -1 then											  
				  goto rrD;											-- CRC �� ������� ==>> ������ �������
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� ������� ���� ������ (0x21) � �������� ���������
----------------------------------------------------------------------------------]]--
				ret = checkError( packet);
				if ret == -1 then										  
				  goto rrD;											-- � ������ ������������ ��� ������ (0x21) ==>> ������ �������
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	��������� ������� ��������� ������ ��1
----------------------------------------------------------------------------------]]--
				devTime = packetHandler( packet, ch);
--------------------------------------------------------------------------------------
				id = id + 1;		-- ��������� �� 1 ����������� ���������
				if id == 256 then	-- ��� ������������ �������� id
					id = 0;
				end
--------------------------------------------------------------------------------------
				if ch == 1 then		-- ������ ������ ������ (1/2)
					ch = 2;
					elseif ch == 2 then
						ch = 1;
				end
--------------------------------------------------------------------------------------
				Core.addLogMsg( "bu: ch: " .. ch);
				Core.addLogMsg( "bu: id: " .. id);
				Core.addLogMsg( "bu: " .. os.date("%d.%m.%Y %H:%M", StartDate));
--[[----------------------------------------------------------------------------------
	���������� ������ ��� ������� �������� ������� ��������� ������ ��2
----------------------------------------------------------------------------------]]--
				ret = preparePacketReqArchive( id, ch, rectype, StartDate, endDate);
				packet = ret;
--[[----------------------------------------------------------------------------------
	������ �������� ������� ��������� ������ ��2
----------------------------------------------------------------------------------]]--
::rrD1::     
				ret = reqResp( packet);
				if ret == -1 then				 	  
					c = c + 1;
					Core.SPT943_Driver_Msg = 
					Core.addLogMsg( "bu: ������ ��������� ������ ��2, ������� " .. c .. " �� " .. tryConnection .. "...");
						if c <= 3 then										 
							os.sleep( 1);
							goto rrD1;								-- ��� ������ �� ������������� ==>> ������ ������� 
							else 
							Core.SPT943_Driver_Msg = 
							Core.addLogMsg( "bu: ����� �������� ��������� ������ ��2 ��������!");	-->> ����� �� ���������
							return -1;
						end
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� CRC
----------------------------------------------------------------------------------]]-- 
				ret = checkCRC( packet);
				if ret == -1 then											  
				  goto rrD1;											-- CRC �� ������� ==>> ������ �������
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� ������� ���� ������ (0x21) � �������� ���������
----------------------------------------------------------------------------------]]--
				ret = checkError( packet);
				if ret == -1 then										  
				  goto rrD1;											-- � ������ ������������ ��� ������ (0x21) ==>> ������ �������
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	��������� ������� ��������� ������ ��2
----------------------------------------------------------------------------------]]--
				devTime = packetHandler( packet, ch);
				if devTime == nil or devTime >= endDate then
					Core.addLogMsg( "bu: ��������� ������� ��������� ������ ��1, ����� ���������� � ����: " .. tostring(devTime));
					fdDate_1:flush();				-- �������� �������� ����� ����� �� ����
					fdDate_1:close();				-- ������� ���������� �����
					fdDate_2:flush();				-- �������� �������� ����� ����� �� ����
					fdDate_2:close();				-- ������� ���������� �����
					break;
				end
--------------------------------------------------------------------------------------				
				id = id + 1;		-- ��������� �� 1 ����������� ���������
				if id == 256 then	-- ��� ������������ �������� id
					id = 0;
				end
--------------------------------------------------------------------------------------
				if ch == 1 then		-- ������ ������ ������ (1/2)
					ch = 2;
					elseif ch == 2 then
						ch = 1;
				end
--------------------------------------------------------------------------------------
				StartDate = devTime;
--------------------------------------------------------------------------------------
				if StartDate >= endDate then	-- ���� ��������� ���� ���������� � �������� ����� �������� ����
					Core.SPT943_Driver_Msg = 
					Core.addLogMsg( "bu: " .. "������ ��������� ������ ���������.");
					fdDate_1:flush();				-- �������� �������� ����� ����� �� ����
					fdDate_1:close();				-- ������� ���������� �����
					fdDate_2:flush();				-- �������� �������� ����� ����� �� ����
					fdDate_2:close();				-- ������� ���������� �����
					break;
				end
			end
		end
--------------------------------------------------------------------------------------
		if userArchTypeMonth == true then -- ����� ��� ��������� ������
		
			rectype = 3;
			StartDate = userStartDate;
			endDate = userEndDate;
			Core.SPT943_Driver_Msg = 
			Core.addLogMsg( "bu: " .. "������ ��������� ������ � " .. os.date( "%d.%m.%Y %H:%M", StartDate) .. " �� " .. os.date( "%d.%m.%Y %H:%M", endDate) .. "...");
			
			fdMonth_1 = io.open( pathMonth_1, "a+");									-- ������� ���� ��������� ������ ��1 �� ��������
			if fdMonth_1 == nil then												-- �������� �������� ����� ��������� ������ ��1
				Core.SPT943_Driver_Msg = 
				Core.addLogMsg( "bu: ������ �������� ����� ��������� ������ ��1!");
				return -1;
			end

			fdMonth_1:setvbuf( "full", 1024);                       				-- ������ ����� ����� - ������ �����������	

			fdMonth_2 = io.open( pathMonth_2, "a+");									-- ������� ���� ��������� ������ ��2 �� ��������
			if fdMonth_2 == nil then												-- �������� �������� ����� ��������� ������ ��2
				Core.SPT943_Driver_Msg = 
				Core.addLogMsg( "bu: ������ �������� ����� ��������� ������ ��2!");
				return -1;
			end

			fdMonth_2:setvbuf( "full", 1024);                       				-- ������ ����� ����� - ������ �����������
--------------------------------------------------------------------------------------			
			while 1 do
				Core.addLogMsg( "bu: ch: " .. ch);
				Core.addLogMsg( "bu: id: " .. id);
				Core.addLogMsg( "bu: " .. os.date("%d.%m.%Y %H:%M", StartDate));
--[[----------------------------------------------------------------------------------
	���������� ������ ��� ������� �������� ������� ��������� ������ ��1
----------------------------------------------------------------------------------]]--
				ret = preparePacketReqArchive( id, ch, rectype, StartDate, endDate);
				packet = ret;
--[[----------------------------------------------------------------------------------
	������ �������� ������� ��������� ������ ��1
----------------------------------------------------------------------------------]]--
::rrM::       
				ret = reqResp( packet);
				if ret == -1 then				 	  
					c = c + 1;
					Core.SPT943_Driver_Msg = 
					Core.addLogMsg( "bu: ������ ��������� ������ ��1, ������� " .. c .. " �� " .. tryConnection .. "...");
						if c <= 3 then										 
						os.sleep( 1);
						goto rrM;								-- ��� ������ �� ������������� ==>> ������ ������� 
							else 
							Core.SPT943_Driver_Msg = 
							Core.addLogMsg( "bu: ����� �������� ��������� ������ ��1 ��������!");	-->> ����� �� ���������
							return -1;
						end
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� CRC
----------------------------------------------------------------------------------]]-- 
				ret = checkCRC( packet);
				if ret == -1 then											  
				  goto rrM;											-- CRC �� ������� ==>> ������ �������
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� ������� ���� ������ (0x21) � �������� ���������
----------------------------------------------------------------------------------]]--
				if checkError( packet) == -1 then										  
				  goto rrM;						-- � ������ ������������ ��� ������ (0x21) ==>> ������ �������
				end
--[[----------------------------------------------------------------------------------
	��������� ������� ��������� ������ ��1
----------------------------------------------------------------------------------]]--
				devTime = packetHandler( packet, ch);
--------------------------------------------------------------------------------------
				id = id + 1;		-- ��������� �� 1 ����������� ���������
				if id == 256 then	-- ��� ������������ �������� id
					id = 0;
				end
--------------------------------------------------------------------------------------
				if ch == 1 then		-- ������ ������ ������ (1/2)
					ch = 2;
					elseif ch == 2 then
						ch = 1;
				end
--------------------------------------------------------------------------------------
				Core.addLogMsg( "bu: ch: " .. ch);
				Core.addLogMsg( "bu: id: " .. id);
				Core.addLogMsg( "bu: " .. os.date("%d.%m.%Y %H:%M", StartDate));
--[[----------------------------------------------------------------------------------
	���������� ������ ��� ������� �������� ������� ��������� ������ ��2
----------------------------------------------------------------------------------]]--
				ret = preparePacketReqArchive( id, ch, rectype, StartDate, endDate);
				packet = ret;
--[[----------------------------------------------------------------------------------
	������ �������� ������� ��������� ������ ��2
----------------------------------------------------------------------------------]]--
::rrM1::       
				ret = reqResp( packet);
				if ret == -1 then				 	  
					c = c + 1;
					Core.SPT943_Driver_Msg = 
					Core.addLogMsg( "bu: ������ ��������� ������ ��2, ������� " .. c .. " �� " .. tryConnection .. "...");
						if c <= 3 then										 
						os.sleep( 1);
						goto rrM1;								-- ��� ������ �� ������������� ==>> ������ ������� 
							else 
							Core.SPT943_Driver_Msg = 
							Core.addLogMsg( "bu: ����� �������� ��������� ������ ��2 ��������!");	-->> ����� �� ���������
							return -1;
						end
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� CRC
----------------------------------------------------------------------------------]]-- 
				ret = checkCRC( packet);
				if ret == -1 then											  
				  goto rrM1;											-- CRC �� ������� ==>> ������ �������
				end
				packet = ret;
--[[----------------------------------------------------------------------------------
	�������� ������� ���� ������ (0x21) � �������� ���������
----------------------------------------------------------------------------------]]--
				if checkError( packet) == -1 then										  
				  goto rrM1;						-- � ������ ������������ ��� ������ (0x21) ==>> ������ �������
				end
--[[----------------------------------------------------------------------------------
	��������� ������� ��������� ������ ��2
----------------------------------------------------------------------------------]]--
				devTime = packetHandler( packet, ch);
				if devTime == nil or devTime >= endDate then
					Core.addLogMsg( "bu: ��������� ������� ��������� ������ ��1, ����� ���������� � ����: " .. tostring(devTime));
					fdMonth_1:flush();				-- �������� �������� ����� ����� �� ����
					fdMonth_1:close();				-- ������� ���������� �����
					fdMonth_2:flush();				-- �������� �������� ����� ����� �� ����
					fdMonth_2:close();				-- ������� ���������� �����
					break;
				end
--------------------------------------------------------------------------------------
				id = id + 1;		-- ��������� �� 1 ����������� ���������
				if id == 256 then	-- ��� ������������ �������� id
					id = 0;
				end
--------------------------------------------------------------------------------------
				if ch == 1 then		-- ������ ������ ������ (1/2)
					ch = 2;
					elseif ch == 2 then
						ch = 1;
				end
--------------------------------------------------------------------------------------
				StartDate = devTime + 86400;	-- ��������� ���� �����
--------------------------------------------------------------------------------------
				if StartDate >= endDate then					-- ���� ��������� ���� ���������� � �������� ����� �������� ����
					Core.SPT943_Driver_Msg = 
					Core.addLogMsg( "bu: " .. "������ ��������� ������ ���������.");
					fdMonth_1:flush();							-- �������� �������� ����� ����� �� ����
					fdMonth_1:close();							-- ������� ���������� �����
					fdMonth_2:flush();							-- �������� �������� ����� ����� �� ����
					fdMonth_2:close();							-- ������� ���������� �����
					break;
				end
			end
		end
	end

--**********************************************************
--********************	  ENTRY	  **************************
--**********************************************************

	local ret;					-- ������������ �������� �������
	local packet;           	-- �����
	local c = 1;                -- ������� �������
	local tryConnection = 3;	-- ���������� ����������� (��������) � �������������

	--local fdLogMsg;		-- ���������� ����� �������
	--local pathFdLogMsg = "C:/!Projects/SPT943/ArchiveFiles/LogMsg.txt";
	
	--fdLogMsg, err = io.open( pathFdLogMsg, "a+");	-- ������� ���� �������� ������ ��1 � ������ ������
	--if fdLogMsg then
	
--[[----------------------------------------------------------------------------------
	�������� COM-�����
----------------------------------------------------------------------------------]]--
	Core.SPT943_Driver_Msg = "�������� " .. portName .. " �� �������� " .. baudRate .. "...";
	Core.addLogMsg( "portOpen: �������� COM-����� (2400)...");
	ret = portOpen( portName, baudRate, dataBits, stopBits, parity);
	if  ret == -1 then				  
	  goto quit;																	-- ������ �������� ����� ==>> ����� �� ���������
	end
--[[----------------------------------------------------------------------------------
	������������� ������ ����� ==> ������� FF,FF...FF
----------------------------------------------------------------------------------]]--
	Core.SPT943_Driver_Msg = "������������� ������ �����..."
	Core.addLogMsg( "initSession: ������������� ������ �����...");
	initSession( initSessionStr);
	os.sleep( 1.5);		
--[[----------------------------------------------------------------------------------
	������ ������ ����� (����������� ������ ���������) ==> ������� 10 FF 3F 00 00 00 00 C1 16
	@param	reqSessionShortStr	string	- ������ ������ (������)
	@return	packet	            table   - �������� ����� (������)
----------------------------------------------------------------------------------]]--
::reqSessionShort::																-- ����� ::reqSessionShort::

	Core.SPT943_Driver_Msg = "������ ������ ����� (����������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...";
	Core.addLogMsg( "reqResp: ������ ������ ����� (����������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...");
	ret = reqResp( reqSessionShortStr);
	if  ret == -1 then				  
		c = c + 1;  
		Core.SPT943_Driver_Msg = "������ ������ ����� (����������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...";
		Core.addLogMsg( "reqResp: ������ ������ ����� (����������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...");
			if c <= 3 then										 
				os.sleep( 1);
				goto reqSessionShort;												-- ��� ������ �� ������������� ==>> ������ ������� 
				else 
				Core.SPT943_Driver_Msg = "����� �������� ������ ����� ��������!";
				Core.addLogMsg( "reqResp: ����� �������� ������ ����� ��������!");	-->> ����� �� ���������
				goto quit;
			end														
	end
	packet = ret;

-- ��������� �����: 10 FF 3F 54 2B 0A 38 16

--[[----------------------------------------------------------------------------------
	�������� ����������� �����
	@param	packet	table	- �������� ����� (������)
	@return -1				- ��� ������������ cs
	@return	packet	table   - ��� ���������� cs
----------------------------------------------------------------------------------]]--
	--Core.addLogMsg( "checkCS: �������� ����������� �����...");
	ret = checkCS( packet);
	if ret == -1 then												
	  goto reqSessionShort;															-- ����������� ����� �� ������� ==>> ������ �������
	end
	packet = ret;
--[[----------------------------------------------------------------------------------
	�������� ������� ���� ������ (0x21) � �������� ���������
	@param	packet	table	- �������� �����
	@return -1				      - ��� ������� ������	
	@return packet	table	- ��� ���������� ������
----------------------------------------------------------------------------------]]--
	--Core.addLogMsg( "checkError: �������� ������� ���� ������ (0x21)...");
	ret = checkError( packet);
	if ret == -1 then										  
	  goto reqSessionShort;															-- � ������ ������������ ��� ������ (0x21) ==>> ������ �������
	end
	packet = ret;
--[[----------------------------------------------------------------------------------
	��������� ������� ������ ����� (����������� ������ ���������)
	@param	packet	- �������� �����
	@return 0
----------------------------------------------------------------------------------]]--
	--Core.addLogMsg( "packetHandler: ��������� ������� ������ ����� (����������� ������ ���������)...");
	packetHandler( packet, ch);
--[[----------------------------------------------------------------------------------
	������ ������ ������ ����� (������� ������ ���������) ==> �������	10 FF 90 00 00 05 00 3F 00 00 00 00 D9 19
----------------------------------------------------------------------------------]]--
::reqSessionFull_1::																-- ����� ::reqSessionFull_1::

	Core.SPT943_Driver_Msg = "������ ������ ����� (������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...";
	Core.addLogMsg( "reqResp: ������ ������ ����� (������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...");
	ret = reqResp( reqSessionFullStr);
	if ret == -1 then				 	  
		c = c + 1;
		Core.SPT943_Driver_Msg = "������ ������ ����� (������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...";
		Core.addLogMsg( "reqResp: ������ ������ ����� (������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...");
			if c <= 3 then										 
				os.sleep( 1);
				goto reqSessionFull_1;												-- ��� ������ �� ������������� ==>> ������ ������� 
				else 
				Core.SPT943_Driver_Msg = "����� �������� ������ ����� ��������!"
				Core.addLogMsg( "reqResp: ����� �������� ������ ����� ��������!");	-->> ����� �� ���������
				goto quit;
			end
	end
	packet = ret;

-- ��������� �����: 10 FF 90 00 00 04 00 3F 54 2B 0A 86 B6
								
--[[----------------------------------------------------------------------------------
	�������� CRC
----------------------------------------------------------------------------------]]--
	--Core.addLogMsg( "checkCRC: �������� CRC...");
	ret = checkCRC( packet);
	if ret == -1 then											  
	  goto reqSessionFull_1;															-- CRC �� ������� ==>> ������ �������
	end
	packet = ret;
--[[----------------------------------------------------------------------------------
	�������� ������� ���� ������ (0x21) � �������� ���������
----------------------------------------------------------------------------------]]--
	--Core.addLogMsg( "checkError: �������� ������� ���� ������ (0x21)...");
	ret = checkError( packet);
	if ret == -1 then										  
	  goto reqSessionFull_1;															-- � ������ ������������ ��� ������ (0x21) ==>> ������ �������
	end
	packet = ret;										
--[[----------------------------------------------------------------------------------
	��������� ������� ������ ����� (������� ������ ���������) 
----------------------------------------------------------------------------------]]--
	--Core.addLogMsg( "packetHandler: ��������� ������� ������ ����� (������� ������ ���������)...");
	packetHandler( packet, ch);
-- ---- --[[----------------------------------------------------------------------------------
-- --	-- ������ ��������� �������� ������ ==> �������  10 FF 90 91 00 05 00 42 03 00 00 00 79 56
-- ---- ----------------------------------------------------------------------------------]]--
::reqChBaudRate::																-- ����� ::reqChBaudRate::
	Core.SPT943_Driver_Msg = "������ ��������� �������� ������, ������� " .. c .. " �� " .. tryConnection .. "...";
	Core.addLogMsg( "reqResp: ������ ��������� �������� ������, ������� " .. c .. " �� " .. tryConnection .. "...");
	ret = reqResp( reqBaudRateStr);
	if ret == -1 then
		Core.SPT943_Driver_Msg = "������ ��������� �������� ������, ������� " .. c .. " �� " .. tryConnection .. "...";
		Core.addLogMsg( "reqResp: ������ ��������� �������� ������, ������� " .. c .. " �� " .. tryConnection .. "...");
			 c = c + 1;
			 if c <= 3 then															-- ��� ������ �� ������������� ==>> ������ ������� 
				 os.sleep( 1);
				 goto reqChBaudRate; 
				 else 
				 Core.SPT943_Driver_Msg = "����� �������� ��������� �������� ������ ��������.";
				 Core.addLogMsg( "reqResp: ����� �������� ��������� �������� ������ ��������.")	-->> ����� �� ���������
				 goto quit;
			 end
	end
	packet = ret;
 -- -- ��������� �����: 10 FF 90 91 00 01 00 42 B8 B8
				
-- --[[----------------------------------------------------------------------------------
	-- �������� CRC
-- ----------------------------------------------------------------------------------]]-- 
	--Core.addLogMsg( "checkCRC: �������� CRC...");
	ret = checkCRC( packet);
	if ret == -1 then											  
	  goto reqChBaudRate;																-- CRC �� ������� ==>> ������ �������
	end
	packet = ret;
-- --[[----------------------------------------------------------------------------------
	-- �������� ������� ���� ������ (0x21) � �������� ���������
-- ----------------------------------------------------------------------------------]]--
	--Core.addLogMsg( "checkError: �������� ������� ���� ������ (0x21)...");
	ret = checkError( packet);
	if ret == -1 then										  
	  goto reqChBaudRate;																-- � ������ ������������ ��� ������ (0x21) ==>> ������ �������
	end
	packet = ret;
-- --[[----------------------------------------------------------------------------------
	-- ��������� ������� ��������� �������� ������ (������� ������ ���������) 
-- ----------------------------------------------------------------------------------]]--
	--Core.addLogMsg( "packetHandler: ��������� ������� ��������� �������� ������...");
	ret = packetHandler( packet, ch);
	if ret == -1 then																	-- ������ �������� COM-����� -->> ����� �� ���������
		goto quit;
	end
--[[----------------------------------------------------------------------------------
	������ ������ ������ ����� (������� ������ ���������) ==> �������	10 FF 90 00 00 05 00 3F 00 00 00 00 D9 19
----------------------------------------------------------------------------------]]--
::reqSessionFull_2::																-- ����� ::reqSessionFull_2::

	Core.SPT943_Driver_Msg = "������ ������ ����� (������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...";
	Core.addLogMsg( "reqResp: ������ ������ ����� (������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...");
	ret = reqResp( reqSessionFullStr);
	if ret == -1 then				 	  
		c = c + 1;
		Core.SPT943_Driver_Msg = "������ ������ ����� (������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...";
		Core.addLogMsg( "reqResp: ������ ������ ����� (������� ������ ���������), ������� " .. c .. " �� " .. tryConnection .. "...");
			if c <= 3 then										 
				os.sleep( 1);
				goto reqSessionFull_2;												-- ��� ������ �� ������������� ==>> ������ ������� 
				else 
				Core.SPT943_Driver_Msg = "����� �������� ������ ����� ��������!";
				Core.addLogMsg( "reqResp: ����� �������� ������ ����� ��������!");	-->> ����� �� ���������
				goto quit;
			end
	end
	packet = ret;

-- ��������� �����: 10 FF 90 00 00 04 00 3F 54 2B 0A 86 B6
								
--[[----------------------------------------------------------------------------------
	�������� CRC
----------------------------------------------------------------------------------]]--
	--Core.addLogMsg( "checkCRC: �������� CRC...");
	ret = checkCRC( packet);
	if ret == -1 then											  
	  goto reqSessionFull_2;															-- CRC �� ������� ==>> ������ �������
	end
	packet = ret;
--[[----------------------------------------------------------------------------------
	�������� ������� ���� ������ (0x21) � �������� ���������
----------------------------------------------------------------------------------]]--
	--Core.addLogMsg( "checkError: �������� ������� ���� ������ (0x21)...");
	ret = checkError( packet);
	if ret == -1 then										  
	  goto reqSessionFull_2;															-- � ������ ������������ ��� ������ (0x21) ==>> ������ �������
	end
	packet = ret;										
--[[----------------------------------------------------------------------------------
	��������� ������� ������ ����� (������� ������ ���������) 
----------------------------------------------------------------------------------]]--
	--Core.addLogMsg( "packetHandler: ��������� ������� ������ ����� (������� ������ ���������)...");
	packetHandler( packet, ch);
	
-- ��� ���� ���� �� �������������:
-- 1 ������ ������ ���������
-- �����
-- ���������

-- 2 ������ ������ ���������
-- �����
-- ���������

-- 3 ������ ������ ���������
-- �����
-- ���������
-- ��� ���� ���� �� �������������:

	ret = bu( userArchTypeHour, userArchTypeDate, userArchTypeMonth, userStartDate, userEndDate);
	if ret == -1 then
		goto quit;
	end
	
	serialPort:clearBuffers( ); -- �������� ������� � ���������� �����
	serialPort:close();			-- ���������� ������
::quit::																			  -- ����� ����� �� ���������
	Core.SPT943_Driver_Msg = "�����.";
	Core.addLogMsg( "�����.");

--**********************************************************
--********************	  EXIT	  **************************
--**********************************************************

end

function f2()
	if Core.StartRequestDate == true then
		f1();
	end
end
Core.onExtChange( {"StartRequestDate"}, f2);
Core.waitEvents();