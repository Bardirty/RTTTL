# Компилятор и линкер
ASM = tasm
LINKER = tlink
LIB = tlib

# Флаги для ассемблера и линкера
ASMFLAGS = /zi /ml /i.\inc
LINKERFLAGS = 

# Исполняемый файл
OUTPUT = main.exe
LIBRARY = intermediate.lib

# Исходные файлы и объектные файлы
SRC_FILES = main.asm src\note_f.asm src\sp_c.asm src\parms\set_oct.asm src\parms\set_nt.asm src\pars\rtttl_p.asm src\pars\note_pr.asm
OBJ_FILES = main.obj src\note_f.obj src\sp_c.obj src\parms\set_oct.obj src\parms\set_nt.obj src\pars\rtttl_p.obj src\pars\note_pr.obj

# Группы объектных файлов для библиотеки
LIB_GROUP = src\note_f.obj src\sp_c.obj src\parms\set_oct.obj src\parms\set_nt.obj
OTHER_FILES = src\pars\rtttl_p.obj src\pars\note_pr.obj

# Правило по умолчанию
all: $(OUTPUT)

# Сборка исполняемого файла
$(OUTPUT): $(LIBRARY) main.obj $(OTHER_FILES)
	@echo ==== Linking $(OUTPUT)... ====
	$(LINKER) main.obj +$(LIBRARY) +src\pars\rtttl_p.obj +src\pars\note_pr.obj, $(OUTPUT)

# Создание промежуточной библиотеки
$(LIBRARY): $(LIB_GROUP)
	@echo ==== Creating library $(LIBRARY)... ====
	$(LIB) $(LIBRARY) +src\note_f.obj +src\sp_c.obj +src\parms\set_oct.obj +src\parms\set_nt.obj

# Сборка объектного файла main.asm
main.obj: main.asm
	@echo ---- Compiling main.asm ----
	$(ASM) $(ASMFLAGS) main.asm

# Сборка объектного файла src\note_f.asm
src\note_f.obj: src\note_f.asm
	@echo ---- Compiling src\note_f.asm ----
	$(ASM) $(ASMFLAGS) src\note_f.asm
	@move note_f.obj src\note_f.obj >nul

# Сборка объектного файла src\sp_c.asm
src\sp_c.obj: src\sp_c.asm
	@echo ---- Compiling src\sp_c.asm ----
	$(ASM) $(ASMFLAGS) src\sp_c.asm
	@move sp_c.obj src\sp_c.obj >nul

# Сборка объектного файла src\parms\set_oct.asm
src\parms\set_oct.obj: src\parms\set_oct.asm
	@echo ---- Compiling src\parms\set_oct.asm ----
	$(ASM) $(ASMFLAGS) src\parms\set_oct.asm
	@move set_oct.obj src\parms\set_oct.obj >nul

# Сборка объектного файла src\parms\set_nt.asm
src\parms\set_nt.obj: src\parms\set_nt.asm
	@echo ---- Compiling src\parms\set_nt.asm ----
	$(ASM) $(ASMFLAGS) src\parms\set_nt.asm
	@move set_nt.obj src\parms\set_nt.obj >nul

# Сборка объектного файла src\pars\rtttl_p.asm
src\pars\rtttl_p.obj: src\pars\rtttl_p.asm
	@echo ---- Compiling src\pars\rtttl_p.asm ----
	$(ASM) $(ASMFLAGS) src\pars\rtttl_p.asm
	@move rtttl_p.obj src\pars\rtttl_p.obj >nul
	
# Сборка объектного файла src\pars\note_pr.asm
src\pars\note_pr.obj: src\pars\note_pr.asm
	@echo ---- Compiling src\pars\note_pr.asm ----
	$(ASM) $(ASMFLAGS) src\pars\note_pr.asm
	@move note_pr.obj src\pars\note_pr.obj >nul

# Очистка временных файлов
clean:
	@echo Cleaning up intermediate files...
	@if exist *.obj del /q *.obj
	@if exist src\*.obj del /q src\*.obj
	@if exist src\parms\*.obj del /q src\parms\*.obj
	@if exist src\pars\*.obj del /q src\pars\*.obj
	@if exist $(OUTPUT) del /q $(OUTPUT)
	@if exist $(LIBRARY) del /q $(LIBRARY)
	@if exist *.map del /q *.map
	@echo Cleanup complete.
