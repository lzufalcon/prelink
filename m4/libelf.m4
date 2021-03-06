#serial 7

dnl Some libelf versions have bugs in Elf64_Sxword conversions.
dnl Detect it.

dnl Written by Jakub Jelinek <jakub@redhat.com>.

AC_DEFUN(AC_LIBELF_SXWORD,
  [AC_TRY_RUN([
#include <errno.h>
#include <fcntl.h>
#include <elf.h>
#include <libelf.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

static unsigned char sparc64_elf[] = {
0x7f,0x45,0x4c,0x46,0x02,0x02,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x01,0x00,0x2b,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x78,
0x00,0x00,0x00,0x02,0x00,0x40,0x00,0x00,0x00,0x00,0x00,0x40,0x00,0x08,0x00,0x05,
0x00,0x00,0x07,0xff,0xf0,0x00,0x00,0x00,0x00,0x2e,0x73,0x79,0x6d,0x74,0x61,0x62,
0x00,0x2e,0x73,0x74,0x72,0x74,0x61,0x62,0x00,0x2e,0x73,0x68,0x73,0x74,0x72,0x74,
0x61,0x62,0x00,0x2e,0x74,0x65,0x78,0x74,0x00,0x2e,0x64,0x61,0x74,0x61,0x00,0x2e,
0x62,0x73,0x73,0x00,0x66,0x6f,0x6f,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1b,0x00,0x00,0x00,0x01,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x06,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x21,0x00,0x00,0x00,0x01,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x27,0x00,0x00,0x00,0x08,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x2c,0x00,0x00,0x00,0x01,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x08,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x11,0x00,0x00,0x00,0x03,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x48,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x30,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x02,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x78,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x78,
0x00,0x00,0x00,0x07,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x08,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x18,0x00,0x00,0x00,0x09,0x00,0x00,0x00,0x03,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x02,0xf0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x02,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x04,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00 };

int main (void)
{
  Elf *elf;
  int fd;
  Elf64_Ehdr *ehdr;
  Elf64_Addr val;
  Elf_Scn *scn;

  fd = open ("conflibelftest", O_RDWR | O_CREAT | O_EXCL, 0600);
  if (fd == -1) exit (1);
  unlink ("conflibelftest");
  if (write (fd, sparc64_elf, sizeof(sparc64_elf)) != sizeof(sparc64_elf))
    exit (1);
  if (lseek (fd, 0, SEEK_SET) != 0) exit (1);
  elf_version (EV_CURRENT);
  elf = elf_begin (fd, ELF_C_RDWR, NULL); if (elf == NULL) exit (2);
  if ((ehdr = elf64_getehdr (elf)) == NULL) exit (3);
  scn = NULL;
  while ((scn = elf_nextscn (elf, scn)) != NULL)
    {
      char *name = NULL;
      Elf64_Shdr *shdr;
      Elf_Data *src, *dst;

      if ((shdr = elf64_getshdr (scn))
	  && (name = elf_strptr (elf, ehdr->e_shstrndx, shdr->sh_name))
	  && !strcmp (name, "foo"))
	{
	  src = elf_rawdata (scn, NULL);
	  if (shdr->sh_size != 8 || src->d_off || src->d_size != 8) exit (4);
	  if (src == NULL || elf_rawdata (scn, src) != NULL) exit (5);
	  if ((dst = elf_newdata (scn)) == NULL) exit (6);
	  dst->d_buf = &val;
	  dst->d_size = 8;
	  dst->d_off = 0;
	  dst->d_type = ELF_T_SXWORD;
	  src->d_type = ELF_T_SXWORD;
	  if (elf64_xlatetom (dst, src, ELFDATA2MSB) == NULL) exit (7);
	  if (val != 0x7fff0000000)
	    exit (42);
	  elf_end (elf);
	  exit (0);
	}
    }
  exit (8);
}
    ],,[AC_MSG_ERROR([libelf does not properly convert Elf64_Sxword quantities.
If you are using libelf-0.7.0, please use patches/libelf-0.7.0.patch.])],
[AC_MSG_WARN([Could not test whether libelf properly converts Elf64_Sxword quantities.
If you are using libelf-0.7.0 and your libelf is buggy, please use
patches/libelf-0.7.0.patch.])])
  ])
