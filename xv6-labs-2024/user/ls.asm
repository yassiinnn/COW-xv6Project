
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2de000ef          	jal	2ea <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	2b6000ef          	jal	2ea <strlen>
  38:	47b5                	li	a5,13
  3a:	00a7f863          	bgeu	a5,a0,4a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  3e:	8526                	mv	a0,s1
  40:	70a2                	ld	ra,40(sp)
  42:	7402                	ld	s0,32(sp)
  44:	64e2                	ld	s1,24(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret
  4a:	e84a                	sd	s2,16(sp)
  4c:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  4e:	8526                	mv	a0,s1
  50:	29a000ef          	jal	2ea <strlen>
  54:	862a                	mv	a2,a0
  56:	00002997          	auipc	s3,0x2
  5a:	fba98993          	addi	s3,s3,-70 # 2010 <buf.0>
  5e:	85a6                	mv	a1,s1
  60:	854e                	mv	a0,s3
  62:	40e000ef          	jal	470 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  66:	8526                	mv	a0,s1
  68:	282000ef          	jal	2ea <strlen>
  6c:	892a                	mv	s2,a0
  6e:	8526                	mv	a0,s1
  70:	27a000ef          	jal	2ea <strlen>
  74:	1902                	slli	s2,s2,0x20
  76:	02095913          	srli	s2,s2,0x20
  7a:	4639                	li	a2,14
  7c:	9e09                	subw	a2,a2,a0
  7e:	02000593          	li	a1,32
  82:	01298533          	add	a0,s3,s2
  86:	292000ef          	jal	318 <memset>
  return buf;
  8a:	84ce                	mv	s1,s3
  8c:	6942                	ld	s2,16(sp)
  8e:	69a2                	ld	s3,8(sp)
  90:	b77d                	j	3e <fmtname+0x3e>

0000000000000092 <ls>:

void
ls(char *path)
{
  92:	d7010113          	addi	sp,sp,-656
  96:	28113423          	sd	ra,648(sp)
  9a:	28813023          	sd	s0,640(sp)
  9e:	27213823          	sd	s2,624(sp)
  a2:	0d00                	addi	s0,sp,656
  a4:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  a6:	4581                	li	a1,0
  a8:	4be000ef          	jal	566 <open>
  ac:	06054363          	bltz	a0,112 <ls+0x80>
  b0:	26913c23          	sd	s1,632(sp)
  b4:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  b6:	d7840593          	addi	a1,s0,-648
  ba:	4c4000ef          	jal	57e <fstat>
  be:	06054363          	bltz	a0,124 <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c2:	d8041783          	lh	a5,-640(s0)
  c6:	4705                	li	a4,1
  c8:	06e78c63          	beq	a5,a4,140 <ls+0xae>
  cc:	37f9                	addiw	a5,a5,-2
  ce:	17c2                	slli	a5,a5,0x30
  d0:	93c1                	srli	a5,a5,0x30
  d2:	02f76263          	bltu	a4,a5,f6 <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  d6:	854a                	mv	a0,s2
  d8:	f29ff0ef          	jal	0 <fmtname>
  dc:	85aa                	mv	a1,a0
  de:	d8842703          	lw	a4,-632(s0)
  e2:	d7c42683          	lw	a3,-644(s0)
  e6:	d8041603          	lh	a2,-640(s0)
  ea:	00001517          	auipc	a0,0x1
  ee:	a3650513          	addi	a0,a0,-1482 # b20 <malloc+0x124>
  f2:	053000ef          	jal	944 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  f6:	8526                	mv	a0,s1
  f8:	456000ef          	jal	54e <close>
  fc:	27813483          	ld	s1,632(sp)
}
 100:	28813083          	ld	ra,648(sp)
 104:	28013403          	ld	s0,640(sp)
 108:	27013903          	ld	s2,624(sp)
 10c:	29010113          	addi	sp,sp,656
 110:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 112:	864a                	mv	a2,s2
 114:	00001597          	auipc	a1,0x1
 118:	9dc58593          	addi	a1,a1,-1572 # af0 <malloc+0xf4>
 11c:	4509                	li	a0,2
 11e:	7fc000ef          	jal	91a <fprintf>
    return;
 122:	bff9                	j	100 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 124:	864a                	mv	a2,s2
 126:	00001597          	auipc	a1,0x1
 12a:	9e258593          	addi	a1,a1,-1566 # b08 <malloc+0x10c>
 12e:	4509                	li	a0,2
 130:	7ea000ef          	jal	91a <fprintf>
    close(fd);
 134:	8526                	mv	a0,s1
 136:	418000ef          	jal	54e <close>
    return;
 13a:	27813483          	ld	s1,632(sp)
 13e:	b7c9                	j	100 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 140:	854a                	mv	a0,s2
 142:	1a8000ef          	jal	2ea <strlen>
 146:	2541                	addiw	a0,a0,16
 148:	20000793          	li	a5,512
 14c:	00a7f963          	bgeu	a5,a0,15e <ls+0xcc>
      printf("ls: path too long\n");
 150:	00001517          	auipc	a0,0x1
 154:	9e050513          	addi	a0,a0,-1568 # b30 <malloc+0x134>
 158:	7ec000ef          	jal	944 <printf>
      break;
 15c:	bf69                	j	f6 <ls+0x64>
 15e:	27313423          	sd	s3,616(sp)
 162:	27413023          	sd	s4,608(sp)
 166:	25513c23          	sd	s5,600(sp)
 16a:	25613823          	sd	s6,592(sp)
 16e:	25713423          	sd	s7,584(sp)
 172:	25813023          	sd	s8,576(sp)
 176:	23913c23          	sd	s9,568(sp)
 17a:	23a13823          	sd	s10,560(sp)
    strcpy(buf, path);
 17e:	da040993          	addi	s3,s0,-608
 182:	85ca                	mv	a1,s2
 184:	854e                	mv	a0,s3
 186:	114000ef          	jal	29a <strcpy>
    p = buf+strlen(buf);
 18a:	854e                	mv	a0,s3
 18c:	15e000ef          	jal	2ea <strlen>
 190:	1502                	slli	a0,a0,0x20
 192:	9101                	srli	a0,a0,0x20
 194:	99aa                	add	s3,s3,a0
    *p++ = '/';
 196:	00198c93          	addi	s9,s3,1
 19a:	02f00793          	li	a5,47
 19e:	00f98023          	sb	a5,0(s3)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a2:	d9040a13          	addi	s4,s0,-624
 1a6:	4941                	li	s2,16
      memmove(p, de.name, DIRSIZ);
 1a8:	d9240c13          	addi	s8,s0,-622
 1ac:	4bb9                	li	s7,14
      if(stat(buf, &st) < 0){
 1ae:	d7840b13          	addi	s6,s0,-648
 1b2:	da040a93          	addi	s5,s0,-608
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1b6:	00001d17          	auipc	s10,0x1
 1ba:	96ad0d13          	addi	s10,s10,-1686 # b20 <malloc+0x124>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1be:	a801                	j	1ce <ls+0x13c>
        printf("ls: cannot stat %s\n", buf);
 1c0:	85d6                	mv	a1,s5
 1c2:	00001517          	auipc	a0,0x1
 1c6:	94650513          	addi	a0,a0,-1722 # b08 <malloc+0x10c>
 1ca:	77a000ef          	jal	944 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ce:	864a                	mv	a2,s2
 1d0:	85d2                	mv	a1,s4
 1d2:	8526                	mv	a0,s1
 1d4:	36a000ef          	jal	53e <read>
 1d8:	05251063          	bne	a0,s2,218 <ls+0x186>
      if(de.inum == 0)
 1dc:	d9045783          	lhu	a5,-624(s0)
 1e0:	d7fd                	beqz	a5,1ce <ls+0x13c>
      memmove(p, de.name, DIRSIZ);
 1e2:	865e                	mv	a2,s7
 1e4:	85e2                	mv	a1,s8
 1e6:	8566                	mv	a0,s9
 1e8:	288000ef          	jal	470 <memmove>
      p[DIRSIZ] = 0;
 1ec:	000987a3          	sb	zero,15(s3)
      if(stat(buf, &st) < 0){
 1f0:	85da                	mv	a1,s6
 1f2:	8556                	mv	a0,s5
 1f4:	1f6000ef          	jal	3ea <stat>
 1f8:	fc0544e3          	bltz	a0,1c0 <ls+0x12e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1fc:	8556                	mv	a0,s5
 1fe:	e03ff0ef          	jal	0 <fmtname>
 202:	85aa                	mv	a1,a0
 204:	d8842703          	lw	a4,-632(s0)
 208:	d7c42683          	lw	a3,-644(s0)
 20c:	d8041603          	lh	a2,-640(s0)
 210:	856a                	mv	a0,s10
 212:	732000ef          	jal	944 <printf>
 216:	bf65                	j	1ce <ls+0x13c>
 218:	26813983          	ld	s3,616(sp)
 21c:	26013a03          	ld	s4,608(sp)
 220:	25813a83          	ld	s5,600(sp)
 224:	25013b03          	ld	s6,592(sp)
 228:	24813b83          	ld	s7,584(sp)
 22c:	24013c03          	ld	s8,576(sp)
 230:	23813c83          	ld	s9,568(sp)
 234:	23013d03          	ld	s10,560(sp)
 238:	bd7d                	j	f6 <ls+0x64>

000000000000023a <main>:

int
main(int argc, char *argv[])
{
 23a:	1101                	addi	sp,sp,-32
 23c:	ec06                	sd	ra,24(sp)
 23e:	e822                	sd	s0,16(sp)
 240:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 242:	4785                	li	a5,1
 244:	02a7d763          	bge	a5,a0,272 <main+0x38>
 248:	e426                	sd	s1,8(sp)
 24a:	e04a                	sd	s2,0(sp)
 24c:	00858493          	addi	s1,a1,8
 250:	ffe5091b          	addiw	s2,a0,-2
 254:	02091793          	slli	a5,s2,0x20
 258:	01d7d913          	srli	s2,a5,0x1d
 25c:	05c1                	addi	a1,a1,16
 25e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 260:	6088                	ld	a0,0(s1)
 262:	e31ff0ef          	jal	92 <ls>
  for(i=1; i<argc; i++)
 266:	04a1                	addi	s1,s1,8
 268:	ff249ce3          	bne	s1,s2,260 <main+0x26>
  exit(0);
 26c:	4501                	li	a0,0
 26e:	2b8000ef          	jal	526 <exit>
 272:	e426                	sd	s1,8(sp)
 274:	e04a                	sd	s2,0(sp)
    ls(".");
 276:	00001517          	auipc	a0,0x1
 27a:	8d250513          	addi	a0,a0,-1838 # b48 <malloc+0x14c>
 27e:	e15ff0ef          	jal	92 <ls>
    exit(0);
 282:	4501                	li	a0,0
 284:	2a2000ef          	jal	526 <exit>

0000000000000288 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 290:	fabff0ef          	jal	23a <main>
  exit(0);
 294:	4501                	li	a0,0
 296:	290000ef          	jal	526 <exit>

000000000000029a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a2:	87aa                	mv	a5,a0
 2a4:	0585                	addi	a1,a1,1
 2a6:	0785                	addi	a5,a5,1
 2a8:	fff5c703          	lbu	a4,-1(a1)
 2ac:	fee78fa3          	sb	a4,-1(a5)
 2b0:	fb75                	bnez	a4,2a4 <strcpy+0xa>
    ;
  return os;
}
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	cb91                	beqz	a5,2da <strcmp+0x20>
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00f71763          	bne	a4,a5,2da <strcmp+0x20>
    p++, q++;
 2d0:	0505                	addi	a0,a0,1
 2d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	fbe5                	bnez	a5,2c8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2da:	0005c503          	lbu	a0,0(a1)
}
 2de:	40a7853b          	subw	a0,a5,a0
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <strlen>:

uint
strlen(const char *s)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	cf99                	beqz	a5,314 <strlen+0x2a>
 2f8:	0505                	addi	a0,a0,1
 2fa:	87aa                	mv	a5,a0
 2fc:	86be                	mv	a3,a5
 2fe:	0785                	addi	a5,a5,1
 300:	fff7c703          	lbu	a4,-1(a5)
 304:	ff65                	bnez	a4,2fc <strlen+0x12>
 306:	40a6853b          	subw	a0,a3,a0
 30a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  for(n = 0; s[n]; n++)
 314:	4501                	li	a0,0
 316:	bfdd                	j	30c <strlen+0x22>

0000000000000318 <memset>:

void*
memset(void *dst, int c, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 320:	ca19                	beqz	a2,336 <memset+0x1e>
 322:	87aa                	mv	a5,a0
 324:	1602                	slli	a2,a2,0x20
 326:	9201                	srli	a2,a2,0x20
 328:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 32c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 330:	0785                	addi	a5,a5,1
 332:	fee79de3          	bne	a5,a4,32c <memset+0x14>
  }
  return dst;
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <strchr>:

char*
strchr(const char *s, char c)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  for(; *s; s++)
 346:	00054783          	lbu	a5,0(a0)
 34a:	cf81                	beqz	a5,362 <strchr+0x24>
    if(*s == c)
 34c:	00f58763          	beq	a1,a5,35a <strchr+0x1c>
  for(; *s; s++)
 350:	0505                	addi	a0,a0,1
 352:	00054783          	lbu	a5,0(a0)
 356:	fbfd                	bnez	a5,34c <strchr+0xe>
      return (char*)s;
  return 0;
 358:	4501                	li	a0,0
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret
  return 0;
 362:	4501                	li	a0,0
 364:	bfdd                	j	35a <strchr+0x1c>

0000000000000366 <gets>:

char*
gets(char *buf, int max)
{
 366:	7159                	addi	sp,sp,-112
 368:	f486                	sd	ra,104(sp)
 36a:	f0a2                	sd	s0,96(sp)
 36c:	eca6                	sd	s1,88(sp)
 36e:	e8ca                	sd	s2,80(sp)
 370:	e4ce                	sd	s3,72(sp)
 372:	e0d2                	sd	s4,64(sp)
 374:	fc56                	sd	s5,56(sp)
 376:	f85a                	sd	s6,48(sp)
 378:	f45e                	sd	s7,40(sp)
 37a:	f062                	sd	s8,32(sp)
 37c:	ec66                	sd	s9,24(sp)
 37e:	e86a                	sd	s10,16(sp)
 380:	1880                	addi	s0,sp,112
 382:	8caa                	mv	s9,a0
 384:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 386:	892a                	mv	s2,a0
 388:	4481                	li	s1,0
    cc = read(0, &c, 1);
 38a:	f9f40b13          	addi	s6,s0,-97
 38e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 390:	4ba9                	li	s7,10
 392:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 394:	8d26                	mv	s10,s1
 396:	0014899b          	addiw	s3,s1,1
 39a:	84ce                	mv	s1,s3
 39c:	0349d563          	bge	s3,s4,3c6 <gets+0x60>
    cc = read(0, &c, 1);
 3a0:	8656                	mv	a2,s5
 3a2:	85da                	mv	a1,s6
 3a4:	4501                	li	a0,0
 3a6:	198000ef          	jal	53e <read>
    if(cc < 1)
 3aa:	00a05e63          	blez	a0,3c6 <gets+0x60>
    buf[i++] = c;
 3ae:	f9f44783          	lbu	a5,-97(s0)
 3b2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b6:	01778763          	beq	a5,s7,3c4 <gets+0x5e>
 3ba:	0905                	addi	s2,s2,1
 3bc:	fd879ce3          	bne	a5,s8,394 <gets+0x2e>
    buf[i++] = c;
 3c0:	8d4e                	mv	s10,s3
 3c2:	a011                	j	3c6 <gets+0x60>
 3c4:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 3c6:	9d66                	add	s10,s10,s9
 3c8:	000d0023          	sb	zero,0(s10)
  return buf;
}
 3cc:	8566                	mv	a0,s9
 3ce:	70a6                	ld	ra,104(sp)
 3d0:	7406                	ld	s0,96(sp)
 3d2:	64e6                	ld	s1,88(sp)
 3d4:	6946                	ld	s2,80(sp)
 3d6:	69a6                	ld	s3,72(sp)
 3d8:	6a06                	ld	s4,64(sp)
 3da:	7ae2                	ld	s5,56(sp)
 3dc:	7b42                	ld	s6,48(sp)
 3de:	7ba2                	ld	s7,40(sp)
 3e0:	7c02                	ld	s8,32(sp)
 3e2:	6ce2                	ld	s9,24(sp)
 3e4:	6d42                	ld	s10,16(sp)
 3e6:	6165                	addi	sp,sp,112
 3e8:	8082                	ret

00000000000003ea <stat>:

int
stat(const char *n, struct stat *st)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	e04a                	sd	s2,0(sp)
 3f2:	1000                	addi	s0,sp,32
 3f4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f6:	4581                	li	a1,0
 3f8:	16e000ef          	jal	566 <open>
  if(fd < 0)
 3fc:	02054263          	bltz	a0,420 <stat+0x36>
 400:	e426                	sd	s1,8(sp)
 402:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 404:	85ca                	mv	a1,s2
 406:	178000ef          	jal	57e <fstat>
 40a:	892a                	mv	s2,a0
  close(fd);
 40c:	8526                	mv	a0,s1
 40e:	140000ef          	jal	54e <close>
  return r;
 412:	64a2                	ld	s1,8(sp)
}
 414:	854a                	mv	a0,s2
 416:	60e2                	ld	ra,24(sp)
 418:	6442                	ld	s0,16(sp)
 41a:	6902                	ld	s2,0(sp)
 41c:	6105                	addi	sp,sp,32
 41e:	8082                	ret
    return -1;
 420:	597d                	li	s2,-1
 422:	bfcd                	j	414 <stat+0x2a>

0000000000000424 <atoi>:

int
atoi(const char *s)
{
 424:	1141                	addi	sp,sp,-16
 426:	e406                	sd	ra,8(sp)
 428:	e022                	sd	s0,0(sp)
 42a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 42c:	00054683          	lbu	a3,0(a0)
 430:	fd06879b          	addiw	a5,a3,-48
 434:	0ff7f793          	zext.b	a5,a5
 438:	4625                	li	a2,9
 43a:	02f66963          	bltu	a2,a5,46c <atoi+0x48>
 43e:	872a                	mv	a4,a0
  n = 0;
 440:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 442:	0705                	addi	a4,a4,1
 444:	0025179b          	slliw	a5,a0,0x2
 448:	9fa9                	addw	a5,a5,a0
 44a:	0017979b          	slliw	a5,a5,0x1
 44e:	9fb5                	addw	a5,a5,a3
 450:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 454:	00074683          	lbu	a3,0(a4)
 458:	fd06879b          	addiw	a5,a3,-48
 45c:	0ff7f793          	zext.b	a5,a5
 460:	fef671e3          	bgeu	a2,a5,442 <atoi+0x1e>
  return n;
}
 464:	60a2                	ld	ra,8(sp)
 466:	6402                	ld	s0,0(sp)
 468:	0141                	addi	sp,sp,16
 46a:	8082                	ret
  n = 0;
 46c:	4501                	li	a0,0
 46e:	bfdd                	j	464 <atoi+0x40>

0000000000000470 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 470:	1141                	addi	sp,sp,-16
 472:	e406                	sd	ra,8(sp)
 474:	e022                	sd	s0,0(sp)
 476:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 478:	02b57563          	bgeu	a0,a1,4a2 <memmove+0x32>
    while(n-- > 0)
 47c:	00c05f63          	blez	a2,49a <memmove+0x2a>
 480:	1602                	slli	a2,a2,0x20
 482:	9201                	srli	a2,a2,0x20
 484:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 488:	872a                	mv	a4,a0
      *dst++ = *src++;
 48a:	0585                	addi	a1,a1,1
 48c:	0705                	addi	a4,a4,1
 48e:	fff5c683          	lbu	a3,-1(a1)
 492:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 496:	fee79ae3          	bne	a5,a4,48a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 49a:	60a2                	ld	ra,8(sp)
 49c:	6402                	ld	s0,0(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
    dst += n;
 4a2:	00c50733          	add	a4,a0,a2
    src += n;
 4a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4a8:	fec059e3          	blez	a2,49a <memmove+0x2a>
 4ac:	fff6079b          	addiw	a5,a2,-1
 4b0:	1782                	slli	a5,a5,0x20
 4b2:	9381                	srli	a5,a5,0x20
 4b4:	fff7c793          	not	a5,a5
 4b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4ba:	15fd                	addi	a1,a1,-1
 4bc:	177d                	addi	a4,a4,-1
 4be:	0005c683          	lbu	a3,0(a1)
 4c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c6:	fef71ae3          	bne	a4,a5,4ba <memmove+0x4a>
 4ca:	bfc1                	j	49a <memmove+0x2a>

00000000000004cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e406                	sd	ra,8(sp)
 4d0:	e022                	sd	s0,0(sp)
 4d2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4d4:	ca0d                	beqz	a2,506 <memcmp+0x3a>
 4d6:	fff6069b          	addiw	a3,a2,-1
 4da:	1682                	slli	a3,a3,0x20
 4dc:	9281                	srli	a3,a3,0x20
 4de:	0685                	addi	a3,a3,1
 4e0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4e2:	00054783          	lbu	a5,0(a0)
 4e6:	0005c703          	lbu	a4,0(a1)
 4ea:	00e79863          	bne	a5,a4,4fa <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4ee:	0505                	addi	a0,a0,1
    p2++;
 4f0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4f2:	fed518e3          	bne	a0,a3,4e2 <memcmp+0x16>
  }
  return 0;
 4f6:	4501                	li	a0,0
 4f8:	a019                	j	4fe <memcmp+0x32>
      return *p1 - *p2;
 4fa:	40e7853b          	subw	a0,a5,a4
}
 4fe:	60a2                	ld	ra,8(sp)
 500:	6402                	ld	s0,0(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret
  return 0;
 506:	4501                	li	a0,0
 508:	bfdd                	j	4fe <memcmp+0x32>

000000000000050a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 50a:	1141                	addi	sp,sp,-16
 50c:	e406                	sd	ra,8(sp)
 50e:	e022                	sd	s0,0(sp)
 510:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 512:	f5fff0ef          	jal	470 <memmove>
}
 516:	60a2                	ld	ra,8(sp)
 518:	6402                	ld	s0,0(sp)
 51a:	0141                	addi	sp,sp,16
 51c:	8082                	ret

000000000000051e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 51e:	4885                	li	a7,1
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <exit>:
.global exit
exit:
 li a7, SYS_exit
 526:	4889                	li	a7,2
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <wait>:
.global wait
wait:
 li a7, SYS_wait
 52e:	488d                	li	a7,3
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 536:	4891                	li	a7,4
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <read>:
.global read
read:
 li a7, SYS_read
 53e:	4895                	li	a7,5
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <write>:
.global write
write:
 li a7, SYS_write
 546:	48c1                	li	a7,16
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <close>:
.global close
close:
 li a7, SYS_close
 54e:	48d5                	li	a7,21
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <kill>:
.global kill
kill:
 li a7, SYS_kill
 556:	4899                	li	a7,6
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <exec>:
.global exec
exec:
 li a7, SYS_exec
 55e:	489d                	li	a7,7
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <open>:
.global open
open:
 li a7, SYS_open
 566:	48bd                	li	a7,15
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 56e:	48c5                	li	a7,17
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 576:	48c9                	li	a7,18
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 57e:	48a1                	li	a7,8
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <link>:
.global link
link:
 li a7, SYS_link
 586:	48cd                	li	a7,19
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 58e:	48d1                	li	a7,20
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 596:	48a5                	li	a7,9
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <dup>:
.global dup
dup:
 li a7, SYS_dup
 59e:	48a9                	li	a7,10
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a6:	48ad                	li	a7,11
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ae:	48b1                	li	a7,12
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b6:	48b5                	li	a7,13
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5be:	48b9                	li	a7,14
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c6:	1101                	addi	sp,sp,-32
 5c8:	ec06                	sd	ra,24(sp)
 5ca:	e822                	sd	s0,16(sp)
 5cc:	1000                	addi	s0,sp,32
 5ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d2:	4605                	li	a2,1
 5d4:	fef40593          	addi	a1,s0,-17
 5d8:	f6fff0ef          	jal	546 <write>
}
 5dc:	60e2                	ld	ra,24(sp)
 5de:	6442                	ld	s0,16(sp)
 5e0:	6105                	addi	sp,sp,32
 5e2:	8082                	ret

00000000000005e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e4:	7139                	addi	sp,sp,-64
 5e6:	fc06                	sd	ra,56(sp)
 5e8:	f822                	sd	s0,48(sp)
 5ea:	f426                	sd	s1,40(sp)
 5ec:	f04a                	sd	s2,32(sp)
 5ee:	ec4e                	sd	s3,24(sp)
 5f0:	0080                	addi	s0,sp,64
 5f2:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f4:	c299                	beqz	a3,5fa <printint+0x16>
 5f6:	0605ce63          	bltz	a1,672 <printint+0x8e>
  neg = 0;
 5fa:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5fc:	fc040313          	addi	t1,s0,-64
  neg = 0;
 600:	869a                	mv	a3,t1
  i = 0;
 602:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 604:	00000817          	auipc	a6,0x0
 608:	55480813          	addi	a6,a6,1364 # b58 <digits>
 60c:	88be                	mv	a7,a5
 60e:	0017851b          	addiw	a0,a5,1
 612:	87aa                	mv	a5,a0
 614:	02c5f73b          	remuw	a4,a1,a2
 618:	1702                	slli	a4,a4,0x20
 61a:	9301                	srli	a4,a4,0x20
 61c:	9742                	add	a4,a4,a6
 61e:	00074703          	lbu	a4,0(a4)
 622:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 626:	872e                	mv	a4,a1
 628:	02c5d5bb          	divuw	a1,a1,a2
 62c:	0685                	addi	a3,a3,1
 62e:	fcc77fe3          	bgeu	a4,a2,60c <printint+0x28>
  if(neg)
 632:	000e0c63          	beqz	t3,64a <printint+0x66>
    buf[i++] = '-';
 636:	fd050793          	addi	a5,a0,-48
 63a:	00878533          	add	a0,a5,s0
 63e:	02d00793          	li	a5,45
 642:	fef50823          	sb	a5,-16(a0)
 646:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 64a:	fff7899b          	addiw	s3,a5,-1
 64e:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 652:	fff4c583          	lbu	a1,-1(s1)
 656:	854a                	mv	a0,s2
 658:	f6fff0ef          	jal	5c6 <putc>
  while(--i >= 0)
 65c:	39fd                	addiw	s3,s3,-1
 65e:	14fd                	addi	s1,s1,-1
 660:	fe09d9e3          	bgez	s3,652 <printint+0x6e>
}
 664:	70e2                	ld	ra,56(sp)
 666:	7442                	ld	s0,48(sp)
 668:	74a2                	ld	s1,40(sp)
 66a:	7902                	ld	s2,32(sp)
 66c:	69e2                	ld	s3,24(sp)
 66e:	6121                	addi	sp,sp,64
 670:	8082                	ret
    x = -xx;
 672:	40b005bb          	negw	a1,a1
    neg = 1;
 676:	4e05                	li	t3,1
    x = -xx;
 678:	b751                	j	5fc <printint+0x18>

000000000000067a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67a:	711d                	addi	sp,sp,-96
 67c:	ec86                	sd	ra,88(sp)
 67e:	e8a2                	sd	s0,80(sp)
 680:	e4a6                	sd	s1,72(sp)
 682:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 684:	0005c483          	lbu	s1,0(a1)
 688:	28048463          	beqz	s1,910 <vprintf+0x296>
 68c:	e0ca                	sd	s2,64(sp)
 68e:	fc4e                	sd	s3,56(sp)
 690:	f852                	sd	s4,48(sp)
 692:	f456                	sd	s5,40(sp)
 694:	f05a                	sd	s6,32(sp)
 696:	ec5e                	sd	s7,24(sp)
 698:	e862                	sd	s8,16(sp)
 69a:	e466                	sd	s9,8(sp)
 69c:	8b2a                	mv	s6,a0
 69e:	8a2e                	mv	s4,a1
 6a0:	8bb2                	mv	s7,a2
  state = 0;
 6a2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6a4:	4901                	li	s2,0
 6a6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6a8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6ac:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6b0:	06c00c93          	li	s9,108
 6b4:	a00d                	j	6d6 <vprintf+0x5c>
        putc(fd, c0);
 6b6:	85a6                	mv	a1,s1
 6b8:	855a                	mv	a0,s6
 6ba:	f0dff0ef          	jal	5c6 <putc>
 6be:	a019                	j	6c4 <vprintf+0x4a>
    } else if(state == '%'){
 6c0:	03598363          	beq	s3,s5,6e6 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6c4:	0019079b          	addiw	a5,s2,1
 6c8:	893e                	mv	s2,a5
 6ca:	873e                	mv	a4,a5
 6cc:	97d2                	add	a5,a5,s4
 6ce:	0007c483          	lbu	s1,0(a5)
 6d2:	22048763          	beqz	s1,900 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 6d6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6da:	fe0993e3          	bnez	s3,6c0 <vprintf+0x46>
      if(c0 == '%'){
 6de:	fd579ce3          	bne	a5,s5,6b6 <vprintf+0x3c>
        state = '%';
 6e2:	89be                	mv	s3,a5
 6e4:	b7c5                	j	6c4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e6:	00ea06b3          	add	a3,s4,a4
 6ea:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6ee:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6f0:	c681                	beqz	a3,6f8 <vprintf+0x7e>
 6f2:	9752                	add	a4,a4,s4
 6f4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6f8:	05878263          	beq	a5,s8,73c <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6fc:	05978c63          	beq	a5,s9,754 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 700:	07500713          	li	a4,117
 704:	0ee78663          	beq	a5,a4,7f0 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 708:	07800713          	li	a4,120
 70c:	12e78863          	beq	a5,a4,83c <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 710:	07000713          	li	a4,112
 714:	14e78d63          	beq	a5,a4,86e <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 718:	07300713          	li	a4,115
 71c:	18e78c63          	beq	a5,a4,8b4 <vprintf+0x23a>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == 'c'){
 720:	06300713          	li	a4,99
 724:	1ce78163          	beq	a5,a4,8e6 <vprintf+0x26c>
        putc(fd, va_arg(ap, int));
      } else if(c0 == '%'){
 728:	02500713          	li	a4,37
 72c:	04e79463          	bne	a5,a4,774 <vprintf+0xfa>
        putc(fd, '%');
 730:	85ba                	mv	a1,a4
 732:	855a                	mv	a0,s6
 734:	e93ff0ef          	jal	5c6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 738:	4981                	li	s3,0
 73a:	b769                	j	6c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 73c:	008b8493          	addi	s1,s7,8
 740:	4685                	li	a3,1
 742:	4629                	li	a2,10
 744:	000ba583          	lw	a1,0(s7)
 748:	855a                	mv	a0,s6
 74a:	e9bff0ef          	jal	5e4 <printint>
 74e:	8ba6                	mv	s7,s1
      state = 0;
 750:	4981                	li	s3,0
 752:	bf8d                	j	6c4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 754:	06400793          	li	a5,100
 758:	02f68963          	beq	a3,a5,78a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 75c:	06c00793          	li	a5,108
 760:	04f68263          	beq	a3,a5,7a4 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 764:	07500793          	li	a5,117
 768:	0af68063          	beq	a3,a5,808 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 76c:	07800793          	li	a5,120
 770:	0ef68263          	beq	a3,a5,854 <vprintf+0x1da>
        putc(fd, '%');
 774:	02500593          	li	a1,37
 778:	855a                	mv	a0,s6
 77a:	e4dff0ef          	jal	5c6 <putc>
        putc(fd, c0);
 77e:	85a6                	mv	a1,s1
 780:	855a                	mv	a0,s6
 782:	e45ff0ef          	jal	5c6 <putc>
      state = 0;
 786:	4981                	li	s3,0
 788:	bf35                	j	6c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 78a:	008b8493          	addi	s1,s7,8
 78e:	4685                	li	a3,1
 790:	4629                	li	a2,10
 792:	000ba583          	lw	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	e4dff0ef          	jal	5e4 <printint>
        i += 1;
 79c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 79e:	8ba6                	mv	s7,s1
      state = 0;
 7a0:	4981                	li	s3,0
        i += 1;
 7a2:	b70d                	j	6c4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7a4:	06400793          	li	a5,100
 7a8:	02f60763          	beq	a2,a5,7d6 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7ac:	07500793          	li	a5,117
 7b0:	06f60963          	beq	a2,a5,822 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7b4:	07800793          	li	a5,120
 7b8:	faf61ee3          	bne	a2,a5,774 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7bc:	008b8493          	addi	s1,s7,8
 7c0:	4681                	li	a3,0
 7c2:	4641                	li	a2,16
 7c4:	000ba583          	lw	a1,0(s7)
 7c8:	855a                	mv	a0,s6
 7ca:	e1bff0ef          	jal	5e4 <printint>
        i += 2;
 7ce:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d0:	8ba6                	mv	s7,s1
      state = 0;
 7d2:	4981                	li	s3,0
        i += 2;
 7d4:	bdc5                	j	6c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d6:	008b8493          	addi	s1,s7,8
 7da:	4685                	li	a3,1
 7dc:	4629                	li	a2,10
 7de:	000ba583          	lw	a1,0(s7)
 7e2:	855a                	mv	a0,s6
 7e4:	e01ff0ef          	jal	5e4 <printint>
        i += 2;
 7e8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ea:	8ba6                	mv	s7,s1
      state = 0;
 7ec:	4981                	li	s3,0
        i += 2;
 7ee:	bdd9                	j	6c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7f0:	008b8493          	addi	s1,s7,8
 7f4:	4681                	li	a3,0
 7f6:	4629                	li	a2,10
 7f8:	000ba583          	lw	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	de7ff0ef          	jal	5e4 <printint>
 802:	8ba6                	mv	s7,s1
      state = 0;
 804:	4981                	li	s3,0
 806:	bd7d                	j	6c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 808:	008b8493          	addi	s1,s7,8
 80c:	4681                	li	a3,0
 80e:	4629                	li	a2,10
 810:	000ba583          	lw	a1,0(s7)
 814:	855a                	mv	a0,s6
 816:	dcfff0ef          	jal	5e4 <printint>
        i += 1;
 81a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 81c:	8ba6                	mv	s7,s1
      state = 0;
 81e:	4981                	li	s3,0
        i += 1;
 820:	b555                	j	6c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 822:	008b8493          	addi	s1,s7,8
 826:	4681                	li	a3,0
 828:	4629                	li	a2,10
 82a:	000ba583          	lw	a1,0(s7)
 82e:	855a                	mv	a0,s6
 830:	db5ff0ef          	jal	5e4 <printint>
        i += 2;
 834:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 836:	8ba6                	mv	s7,s1
      state = 0;
 838:	4981                	li	s3,0
        i += 2;
 83a:	b569                	j	6c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 83c:	008b8493          	addi	s1,s7,8
 840:	4681                	li	a3,0
 842:	4641                	li	a2,16
 844:	000ba583          	lw	a1,0(s7)
 848:	855a                	mv	a0,s6
 84a:	d9bff0ef          	jal	5e4 <printint>
 84e:	8ba6                	mv	s7,s1
      state = 0;
 850:	4981                	li	s3,0
 852:	bd8d                	j	6c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 854:	008b8493          	addi	s1,s7,8
 858:	4681                	li	a3,0
 85a:	4641                	li	a2,16
 85c:	000ba583          	lw	a1,0(s7)
 860:	855a                	mv	a0,s6
 862:	d83ff0ef          	jal	5e4 <printint>
        i += 1;
 866:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 868:	8ba6                	mv	s7,s1
      state = 0;
 86a:	4981                	li	s3,0
        i += 1;
 86c:	bda1                	j	6c4 <vprintf+0x4a>
 86e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 870:	008b8d13          	addi	s10,s7,8
 874:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 878:	03000593          	li	a1,48
 87c:	855a                	mv	a0,s6
 87e:	d49ff0ef          	jal	5c6 <putc>
  putc(fd, 'x');
 882:	07800593          	li	a1,120
 886:	855a                	mv	a0,s6
 888:	d3fff0ef          	jal	5c6 <putc>
 88c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 88e:	00000b97          	auipc	s7,0x0
 892:	2cab8b93          	addi	s7,s7,714 # b58 <digits>
 896:	03c9d793          	srli	a5,s3,0x3c
 89a:	97de                	add	a5,a5,s7
 89c:	0007c583          	lbu	a1,0(a5)
 8a0:	855a                	mv	a0,s6
 8a2:	d25ff0ef          	jal	5c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8a6:	0992                	slli	s3,s3,0x4
 8a8:	34fd                	addiw	s1,s1,-1
 8aa:	f4f5                	bnez	s1,896 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8ac:	8bea                	mv	s7,s10
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	6d02                	ld	s10,0(sp)
 8b2:	bd09                	j	6c4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8b4:	008b8993          	addi	s3,s7,8
 8b8:	000bb483          	ld	s1,0(s7)
 8bc:	cc91                	beqz	s1,8d8 <vprintf+0x25e>
        for(; *s; s++)
 8be:	0004c583          	lbu	a1,0(s1)
 8c2:	cd85                	beqz	a1,8fa <vprintf+0x280>
          putc(fd, *s);
 8c4:	855a                	mv	a0,s6
 8c6:	d01ff0ef          	jal	5c6 <putc>
        for(; *s; s++)
 8ca:	0485                	addi	s1,s1,1
 8cc:	0004c583          	lbu	a1,0(s1)
 8d0:	f9f5                	bnez	a1,8c4 <vprintf+0x24a>
        if((s = va_arg(ap, char*)) == 0)
 8d2:	8bce                	mv	s7,s3
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	b3fd                	j	6c4 <vprintf+0x4a>
          s = "(null)";
 8d8:	00000497          	auipc	s1,0x0
 8dc:	27848493          	addi	s1,s1,632 # b50 <malloc+0x154>
        for(; *s; s++)
 8e0:	02800593          	li	a1,40
 8e4:	b7c5                	j	8c4 <vprintf+0x24a>
        putc(fd, va_arg(ap, int));
 8e6:	008b8493          	addi	s1,s7,8
 8ea:	000bc583          	lbu	a1,0(s7)
 8ee:	855a                	mv	a0,s6
 8f0:	cd7ff0ef          	jal	5c6 <putc>
 8f4:	8ba6                	mv	s7,s1
      state = 0;
 8f6:	4981                	li	s3,0
 8f8:	b3f1                	j	6c4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8fa:	8bce                	mv	s7,s3
      state = 0;
 8fc:	4981                	li	s3,0
 8fe:	b3d9                	j	6c4 <vprintf+0x4a>
 900:	6906                	ld	s2,64(sp)
 902:	79e2                	ld	s3,56(sp)
 904:	7a42                	ld	s4,48(sp)
 906:	7aa2                	ld	s5,40(sp)
 908:	7b02                	ld	s6,32(sp)
 90a:	6be2                	ld	s7,24(sp)
 90c:	6c42                	ld	s8,16(sp)
 90e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 910:	60e6                	ld	ra,88(sp)
 912:	6446                	ld	s0,80(sp)
 914:	64a6                	ld	s1,72(sp)
 916:	6125                	addi	sp,sp,96
 918:	8082                	ret

000000000000091a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 91a:	715d                	addi	sp,sp,-80
 91c:	ec06                	sd	ra,24(sp)
 91e:	e822                	sd	s0,16(sp)
 920:	1000                	addi	s0,sp,32
 922:	e010                	sd	a2,0(s0)
 924:	e414                	sd	a3,8(s0)
 926:	e818                	sd	a4,16(s0)
 928:	ec1c                	sd	a5,24(s0)
 92a:	03043023          	sd	a6,32(s0)
 92e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 932:	8622                	mv	a2,s0
 934:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 938:	d43ff0ef          	jal	67a <vprintf>
  va_end(ap);
}
 93c:	60e2                	ld	ra,24(sp)
 93e:	6442                	ld	s0,16(sp)
 940:	6161                	addi	sp,sp,80
 942:	8082                	ret

0000000000000944 <printf>:

void
printf(const char *fmt, ...)
{
 944:	711d                	addi	sp,sp,-96
 946:	ec06                	sd	ra,24(sp)
 948:	e822                	sd	s0,16(sp)
 94a:	1000                	addi	s0,sp,32
 94c:	e40c                	sd	a1,8(s0)
 94e:	e810                	sd	a2,16(s0)
 950:	ec14                	sd	a3,24(s0)
 952:	f018                	sd	a4,32(s0)
 954:	f41c                	sd	a5,40(s0)
 956:	03043823          	sd	a6,48(s0)
 95a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 95e:	00840613          	addi	a2,s0,8
 962:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 966:	85aa                	mv	a1,a0
 968:	4505                	li	a0,1
 96a:	d11ff0ef          	jal	67a <vprintf>
  va_end(ap);
}
 96e:	60e2                	ld	ra,24(sp)
 970:	6442                	ld	s0,16(sp)
 972:	6125                	addi	sp,sp,96
 974:	8082                	ret

0000000000000976 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 976:	1141                	addi	sp,sp,-16
 978:	e406                	sd	ra,8(sp)
 97a:	e022                	sd	s0,0(sp)
 97c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 97e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 982:	00001797          	auipc	a5,0x1
 986:	67e7b783          	ld	a5,1662(a5) # 2000 <freep>
 98a:	a02d                	j	9b4 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 98c:	4618                	lw	a4,8(a2)
 98e:	9f2d                	addw	a4,a4,a1
 990:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 994:	6398                	ld	a4,0(a5)
 996:	6310                	ld	a2,0(a4)
 998:	a83d                	j	9d6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 99a:	ff852703          	lw	a4,-8(a0)
 99e:	9f31                	addw	a4,a4,a2
 9a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9a2:	ff053683          	ld	a3,-16(a0)
 9a6:	a091                	j	9ea <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a8:	6398                	ld	a4,0(a5)
 9aa:	00e7e463          	bltu	a5,a4,9b2 <free+0x3c>
 9ae:	00e6ea63          	bltu	a3,a4,9c2 <free+0x4c>
{
 9b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b4:	fed7fae3          	bgeu	a5,a3,9a8 <free+0x32>
 9b8:	6398                	ld	a4,0(a5)
 9ba:	00e6e463          	bltu	a3,a4,9c2 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9be:	fee7eae3          	bltu	a5,a4,9b2 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9c2:	ff852583          	lw	a1,-8(a0)
 9c6:	6390                	ld	a2,0(a5)
 9c8:	02059813          	slli	a6,a1,0x20
 9cc:	01c85713          	srli	a4,a6,0x1c
 9d0:	9736                	add	a4,a4,a3
 9d2:	fae60de3          	beq	a2,a4,98c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9da:	4790                	lw	a2,8(a5)
 9dc:	02061593          	slli	a1,a2,0x20
 9e0:	01c5d713          	srli	a4,a1,0x1c
 9e4:	973e                	add	a4,a4,a5
 9e6:	fae68ae3          	beq	a3,a4,99a <free+0x24>
    p->s.ptr = bp->s.ptr;
 9ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9ec:	00001717          	auipc	a4,0x1
 9f0:	60f73a23          	sd	a5,1556(a4) # 2000 <freep>
}
 9f4:	60a2                	ld	ra,8(sp)
 9f6:	6402                	ld	s0,0(sp)
 9f8:	0141                	addi	sp,sp,16
 9fa:	8082                	ret

00000000000009fc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9fc:	7139                	addi	sp,sp,-64
 9fe:	fc06                	sd	ra,56(sp)
 a00:	f822                	sd	s0,48(sp)
 a02:	f04a                	sd	s2,32(sp)
 a04:	ec4e                	sd	s3,24(sp)
 a06:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a08:	02051993          	slli	s3,a0,0x20
 a0c:	0209d993          	srli	s3,s3,0x20
 a10:	09bd                	addi	s3,s3,15
 a12:	0049d993          	srli	s3,s3,0x4
 a16:	2985                	addiw	s3,s3,1
 a18:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a1a:	00001517          	auipc	a0,0x1
 a1e:	5e653503          	ld	a0,1510(a0) # 2000 <freep>
 a22:	c905                	beqz	a0,a52 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a24:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a26:	4798                	lw	a4,8(a5)
 a28:	09377663          	bgeu	a4,s3,ab4 <malloc+0xb8>
 a2c:	f426                	sd	s1,40(sp)
 a2e:	e852                	sd	s4,16(sp)
 a30:	e456                	sd	s5,8(sp)
 a32:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a34:	8a4e                	mv	s4,s3
 a36:	6705                	lui	a4,0x1
 a38:	00e9f363          	bgeu	s3,a4,a3e <malloc+0x42>
 a3c:	6a05                	lui	s4,0x1
 a3e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a42:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a46:	00001497          	auipc	s1,0x1
 a4a:	5ba48493          	addi	s1,s1,1466 # 2000 <freep>
  if(p == (char*)-1)
 a4e:	5afd                	li	s5,-1
 a50:	a83d                	j	a8e <malloc+0x92>
 a52:	f426                	sd	s1,40(sp)
 a54:	e852                	sd	s4,16(sp)
 a56:	e456                	sd	s5,8(sp)
 a58:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a5a:	00001797          	auipc	a5,0x1
 a5e:	5c678793          	addi	a5,a5,1478 # 2020 <base>
 a62:	00001717          	auipc	a4,0x1
 a66:	58f73f23          	sd	a5,1438(a4) # 2000 <freep>
 a6a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a6c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a70:	b7d1                	j	a34 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a72:	6398                	ld	a4,0(a5)
 a74:	e118                	sd	a4,0(a0)
 a76:	a899                	j	acc <malloc+0xd0>
  hp->s.size = nu;
 a78:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a7c:	0541                	addi	a0,a0,16
 a7e:	ef9ff0ef          	jal	976 <free>
  return freep;
 a82:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a84:	c125                	beqz	a0,ae4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a86:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a88:	4798                	lw	a4,8(a5)
 a8a:	03277163          	bgeu	a4,s2,aac <malloc+0xb0>
    if(p == freep)
 a8e:	6098                	ld	a4,0(s1)
 a90:	853e                	mv	a0,a5
 a92:	fef71ae3          	bne	a4,a5,a86 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a96:	8552                	mv	a0,s4
 a98:	b17ff0ef          	jal	5ae <sbrk>
  if(p == (char*)-1)
 a9c:	fd551ee3          	bne	a0,s5,a78 <malloc+0x7c>
        return 0;
 aa0:	4501                	li	a0,0
 aa2:	74a2                	ld	s1,40(sp)
 aa4:	6a42                	ld	s4,16(sp)
 aa6:	6aa2                	ld	s5,8(sp)
 aa8:	6b02                	ld	s6,0(sp)
 aaa:	a03d                	j	ad8 <malloc+0xdc>
 aac:	74a2                	ld	s1,40(sp)
 aae:	6a42                	ld	s4,16(sp)
 ab0:	6aa2                	ld	s5,8(sp)
 ab2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ab4:	fae90fe3          	beq	s2,a4,a72 <malloc+0x76>
        p->s.size -= nunits;
 ab8:	4137073b          	subw	a4,a4,s3
 abc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 abe:	02071693          	slli	a3,a4,0x20
 ac2:	01c6d713          	srli	a4,a3,0x1c
 ac6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ac8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 acc:	00001717          	auipc	a4,0x1
 ad0:	52a73a23          	sd	a0,1332(a4) # 2000 <freep>
      return (void*)(p + 1);
 ad4:	01078513          	addi	a0,a5,16
  }
}
 ad8:	70e2                	ld	ra,56(sp)
 ada:	7442                	ld	s0,48(sp)
 adc:	7902                	ld	s2,32(sp)
 ade:	69e2                	ld	s3,24(sp)
 ae0:	6121                	addi	sp,sp,64
 ae2:	8082                	ret
 ae4:	74a2                	ld	s1,40(sp)
 ae6:	6a42                	ld	s4,16(sp)
 ae8:	6aa2                	ld	s5,8(sp)
 aea:	6b02                	ld	s6,0(sp)
 aec:	b7f5                	j	ad8 <malloc+0xdc>
