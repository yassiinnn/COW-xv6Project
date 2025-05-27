
user/_cowTest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main() {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  printf("COW test starting\n");
   a:	00001517          	auipc	a0,0x1
   e:	8e650513          	addi	a0,a0,-1818 # 8f0 <malloc+0xf8>
  12:	72e000ef          	jal	740 <printf>

  char *p = sbrk(0);     // get current break
  16:	4501                	li	a0,0
  18:	392000ef          	jal	3aa <sbrk>
  1c:	84aa                	mv	s1,a0
  sbrk(1);               // allocate a page
  1e:	4505                	li	a0,1
  20:	38a000ef          	jal	3aa <sbrk>
  p[0] = 'A';            // write something
  24:	04100793          	li	a5,65
  28:	00f48023          	sb	a5,0(s1)

  int pid = fork();
  2c:	2ee000ef          	jal	31a <fork>
  if(pid == 0) {
  30:	e515                	bnez	a0,5c <main+0x5c>
    // Child
    printf("Child reads: %c\n", p[0]);
  32:	0004c583          	lbu	a1,0(s1)
  36:	00001517          	auipc	a0,0x1
  3a:	8d250513          	addi	a0,a0,-1838 # 908 <malloc+0x110>
  3e:	702000ef          	jal	740 <printf>
    p[0] = 'B';          // Trigger COW
  42:	04200593          	li	a1,66
  46:	00b48023          	sb	a1,0(s1)
    printf("Child writes and reads: %c\n", p[0]);
  4a:	00001517          	auipc	a0,0x1
  4e:	8d650513          	addi	a0,a0,-1834 # 920 <malloc+0x128>
  52:	6ee000ef          	jal	740 <printf>
    exit(0);
  56:	4501                	li	a0,0
  58:	2ca000ef          	jal	322 <exit>
  } else {
    wait(0);
  5c:	4501                	li	a0,0
  5e:	2cc000ef          	jal	32a <wait>
    printf("Parent reads again: %c\n", p[0]);  // should still be 'A'
  62:	0004c583          	lbu	a1,0(s1)
  66:	00001517          	auipc	a0,0x1
  6a:	8da50513          	addi	a0,a0,-1830 # 940 <malloc+0x148>
  6e:	6d2000ef          	jal	740 <printf>
  }

  printf("COW test done\n");
  72:	00001517          	auipc	a0,0x1
  76:	8e650513          	addi	a0,a0,-1818 # 958 <malloc+0x160>
  7a:	6c6000ef          	jal	740 <printf>
  exit(0);
  7e:	4501                	li	a0,0
  80:	2a2000ef          	jal	322 <exit>

0000000000000084 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  8c:	f75ff0ef          	jal	0 <main>
  exit(0);
  90:	4501                	li	a0,0
  92:	290000ef          	jal	322 <exit>

0000000000000096 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9e:	87aa                	mv	a5,a0
  a0:	0585                	addi	a1,a1,1
  a2:	0785                	addi	a5,a5,1
  a4:	fff5c703          	lbu	a4,-1(a1)
  a8:	fee78fa3          	sb	a4,-1(a5)
  ac:	fb75                	bnez	a4,a0 <strcpy+0xa>
    ;
  return os;
}
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e406                	sd	ra,8(sp)
  ba:	e022                	sd	s0,0(sp)
  bc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cb91                	beqz	a5,d6 <strcmp+0x20>
  c4:	0005c703          	lbu	a4,0(a1)
  c8:	00f71763          	bne	a4,a5,d6 <strcmp+0x20>
    p++, q++;
  cc:	0505                	addi	a0,a0,1
  ce:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbe5                	bnez	a5,c4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  d6:	0005c503          	lbu	a0,0(a1)
}
  da:	40a7853b          	subw	a0,a5,a0
  de:	60a2                	ld	ra,8(sp)
  e0:	6402                	ld	s0,0(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret

00000000000000e6 <strlen>:

uint
strlen(const char *s)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cf99                	beqz	a5,110 <strlen+0x2a>
  f4:	0505                	addi	a0,a0,1
  f6:	87aa                	mv	a5,a0
  f8:	86be                	mv	a3,a5
  fa:	0785                	addi	a5,a5,1
  fc:	fff7c703          	lbu	a4,-1(a5)
 100:	ff65                	bnez	a4,f8 <strlen+0x12>
 102:	40a6853b          	subw	a0,a3,a0
 106:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 108:	60a2                	ld	ra,8(sp)
 10a:	6402                	ld	s0,0(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret
  for(n = 0; s[n]; n++)
 110:	4501                	li	a0,0
 112:	bfdd                	j	108 <strlen+0x22>

0000000000000114 <memset>:

void*
memset(void *dst, int c, uint n)
{
 114:	1141                	addi	sp,sp,-16
 116:	e406                	sd	ra,8(sp)
 118:	e022                	sd	s0,0(sp)
 11a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 11c:	ca19                	beqz	a2,132 <memset+0x1e>
 11e:	87aa                	mv	a5,a0
 120:	1602                	slli	a2,a2,0x20
 122:	9201                	srli	a2,a2,0x20
 124:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 128:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 12c:	0785                	addi	a5,a5,1
 12e:	fee79de3          	bne	a5,a4,128 <memset+0x14>
  }
  return dst;
}
 132:	60a2                	ld	ra,8(sp)
 134:	6402                	ld	s0,0(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strchr>:

char*
strchr(const char *s, char c)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e406                	sd	ra,8(sp)
 13e:	e022                	sd	s0,0(sp)
 140:	0800                	addi	s0,sp,16
  for(; *s; s++)
 142:	00054783          	lbu	a5,0(a0)
 146:	cf81                	beqz	a5,15e <strchr+0x24>
    if(*s == c)
 148:	00f58763          	beq	a1,a5,156 <strchr+0x1c>
  for(; *s; s++)
 14c:	0505                	addi	a0,a0,1
 14e:	00054783          	lbu	a5,0(a0)
 152:	fbfd                	bnez	a5,148 <strchr+0xe>
      return (char*)s;
  return 0;
 154:	4501                	li	a0,0
}
 156:	60a2                	ld	ra,8(sp)
 158:	6402                	ld	s0,0(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret
  return 0;
 15e:	4501                	li	a0,0
 160:	bfdd                	j	156 <strchr+0x1c>

0000000000000162 <gets>:

char*
gets(char *buf, int max)
{
 162:	7159                	addi	sp,sp,-112
 164:	f486                	sd	ra,104(sp)
 166:	f0a2                	sd	s0,96(sp)
 168:	eca6                	sd	s1,88(sp)
 16a:	e8ca                	sd	s2,80(sp)
 16c:	e4ce                	sd	s3,72(sp)
 16e:	e0d2                	sd	s4,64(sp)
 170:	fc56                	sd	s5,56(sp)
 172:	f85a                	sd	s6,48(sp)
 174:	f45e                	sd	s7,40(sp)
 176:	f062                	sd	s8,32(sp)
 178:	ec66                	sd	s9,24(sp)
 17a:	e86a                	sd	s10,16(sp)
 17c:	1880                	addi	s0,sp,112
 17e:	8caa                	mv	s9,a0
 180:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	892a                	mv	s2,a0
 184:	4481                	li	s1,0
    cc = read(0, &c, 1);
 186:	f9f40b13          	addi	s6,s0,-97
 18a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 18c:	4ba9                	li	s7,10
 18e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 190:	8d26                	mv	s10,s1
 192:	0014899b          	addiw	s3,s1,1
 196:	84ce                	mv	s1,s3
 198:	0349d563          	bge	s3,s4,1c2 <gets+0x60>
    cc = read(0, &c, 1);
 19c:	8656                	mv	a2,s5
 19e:	85da                	mv	a1,s6
 1a0:	4501                	li	a0,0
 1a2:	198000ef          	jal	33a <read>
    if(cc < 1)
 1a6:	00a05e63          	blez	a0,1c2 <gets+0x60>
    buf[i++] = c;
 1aa:	f9f44783          	lbu	a5,-97(s0)
 1ae:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1b2:	01778763          	beq	a5,s7,1c0 <gets+0x5e>
 1b6:	0905                	addi	s2,s2,1
 1b8:	fd879ce3          	bne	a5,s8,190 <gets+0x2e>
    buf[i++] = c;
 1bc:	8d4e                	mv	s10,s3
 1be:	a011                	j	1c2 <gets+0x60>
 1c0:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1c2:	9d66                	add	s10,s10,s9
 1c4:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1c8:	8566                	mv	a0,s9
 1ca:	70a6                	ld	ra,104(sp)
 1cc:	7406                	ld	s0,96(sp)
 1ce:	64e6                	ld	s1,88(sp)
 1d0:	6946                	ld	s2,80(sp)
 1d2:	69a6                	ld	s3,72(sp)
 1d4:	6a06                	ld	s4,64(sp)
 1d6:	7ae2                	ld	s5,56(sp)
 1d8:	7b42                	ld	s6,48(sp)
 1da:	7ba2                	ld	s7,40(sp)
 1dc:	7c02                	ld	s8,32(sp)
 1de:	6ce2                	ld	s9,24(sp)
 1e0:	6d42                	ld	s10,16(sp)
 1e2:	6165                	addi	sp,sp,112
 1e4:	8082                	ret

00000000000001e6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e6:	1101                	addi	sp,sp,-32
 1e8:	ec06                	sd	ra,24(sp)
 1ea:	e822                	sd	s0,16(sp)
 1ec:	e04a                	sd	s2,0(sp)
 1ee:	1000                	addi	s0,sp,32
 1f0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	4581                	li	a1,0
 1f4:	16e000ef          	jal	362 <open>
  if(fd < 0)
 1f8:	02054263          	bltz	a0,21c <stat+0x36>
 1fc:	e426                	sd	s1,8(sp)
 1fe:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 200:	85ca                	mv	a1,s2
 202:	178000ef          	jal	37a <fstat>
 206:	892a                	mv	s2,a0
  close(fd);
 208:	8526                	mv	a0,s1
 20a:	140000ef          	jal	34a <close>
  return r;
 20e:	64a2                	ld	s1,8(sp)
}
 210:	854a                	mv	a0,s2
 212:	60e2                	ld	ra,24(sp)
 214:	6442                	ld	s0,16(sp)
 216:	6902                	ld	s2,0(sp)
 218:	6105                	addi	sp,sp,32
 21a:	8082                	ret
    return -1;
 21c:	597d                	li	s2,-1
 21e:	bfcd                	j	210 <stat+0x2a>

0000000000000220 <atoi>:

int
atoi(const char *s)
{
 220:	1141                	addi	sp,sp,-16
 222:	e406                	sd	ra,8(sp)
 224:	e022                	sd	s0,0(sp)
 226:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 228:	00054683          	lbu	a3,0(a0)
 22c:	fd06879b          	addiw	a5,a3,-48
 230:	0ff7f793          	zext.b	a5,a5
 234:	4625                	li	a2,9
 236:	02f66963          	bltu	a2,a5,268 <atoi+0x48>
 23a:	872a                	mv	a4,a0
  n = 0;
 23c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 23e:	0705                	addi	a4,a4,1
 240:	0025179b          	slliw	a5,a0,0x2
 244:	9fa9                	addw	a5,a5,a0
 246:	0017979b          	slliw	a5,a5,0x1
 24a:	9fb5                	addw	a5,a5,a3
 24c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 250:	00074683          	lbu	a3,0(a4)
 254:	fd06879b          	addiw	a5,a3,-48
 258:	0ff7f793          	zext.b	a5,a5
 25c:	fef671e3          	bgeu	a2,a5,23e <atoi+0x1e>
  return n;
}
 260:	60a2                	ld	ra,8(sp)
 262:	6402                	ld	s0,0(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  n = 0;
 268:	4501                	li	a0,0
 26a:	bfdd                	j	260 <atoi+0x40>

000000000000026c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 274:	02b57563          	bgeu	a0,a1,29e <memmove+0x32>
    while(n-- > 0)
 278:	00c05f63          	blez	a2,296 <memmove+0x2a>
 27c:	1602                	slli	a2,a2,0x20
 27e:	9201                	srli	a2,a2,0x20
 280:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 284:	872a                	mv	a4,a0
      *dst++ = *src++;
 286:	0585                	addi	a1,a1,1
 288:	0705                	addi	a4,a4,1
 28a:	fff5c683          	lbu	a3,-1(a1)
 28e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 292:	fee79ae3          	bne	a5,a4,286 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 296:	60a2                	ld	ra,8(sp)
 298:	6402                	ld	s0,0(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
    dst += n;
 29e:	00c50733          	add	a4,a0,a2
    src += n;
 2a2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a4:	fec059e3          	blez	a2,296 <memmove+0x2a>
 2a8:	fff6079b          	addiw	a5,a2,-1
 2ac:	1782                	slli	a5,a5,0x20
 2ae:	9381                	srli	a5,a5,0x20
 2b0:	fff7c793          	not	a5,a5
 2b4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b6:	15fd                	addi	a1,a1,-1
 2b8:	177d                	addi	a4,a4,-1
 2ba:	0005c683          	lbu	a3,0(a1)
 2be:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c2:	fef71ae3          	bne	a4,a5,2b6 <memmove+0x4a>
 2c6:	bfc1                	j	296 <memmove+0x2a>

00000000000002c8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d0:	ca0d                	beqz	a2,302 <memcmp+0x3a>
 2d2:	fff6069b          	addiw	a3,a2,-1
 2d6:	1682                	slli	a3,a3,0x20
 2d8:	9281                	srli	a3,a3,0x20
 2da:	0685                	addi	a3,a3,1
 2dc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	0005c703          	lbu	a4,0(a1)
 2e6:	00e79863          	bne	a5,a4,2f6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2ea:	0505                	addi	a0,a0,1
    p2++;
 2ec:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ee:	fed518e3          	bne	a0,a3,2de <memcmp+0x16>
  }
  return 0;
 2f2:	4501                	li	a0,0
 2f4:	a019                	j	2fa <memcmp+0x32>
      return *p1 - *p2;
 2f6:	40e7853b          	subw	a0,a5,a4
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
  return 0;
 302:	4501                	li	a0,0
 304:	bfdd                	j	2fa <memcmp+0x32>

0000000000000306 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 306:	1141                	addi	sp,sp,-16
 308:	e406                	sd	ra,8(sp)
 30a:	e022                	sd	s0,0(sp)
 30c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30e:	f5fff0ef          	jal	26c <memmove>
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31a:	4885                	li	a7,1
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exit>:
.global exit
exit:
 li a7, SYS_exit
 322:	4889                	li	a7,2
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <wait>:
.global wait
wait:
 li a7, SYS_wait
 32a:	488d                	li	a7,3
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 332:	4891                	li	a7,4
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <read>:
.global read
read:
 li a7, SYS_read
 33a:	4895                	li	a7,5
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <write>:
.global write
write:
 li a7, SYS_write
 342:	48c1                	li	a7,16
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <close>:
.global close
close:
 li a7, SYS_close
 34a:	48d5                	li	a7,21
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <kill>:
.global kill
kill:
 li a7, SYS_kill
 352:	4899                	li	a7,6
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exec>:
.global exec
exec:
 li a7, SYS_exec
 35a:	489d                	li	a7,7
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <open>:
.global open
open:
 li a7, SYS_open
 362:	48bd                	li	a7,15
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36a:	48c5                	li	a7,17
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 372:	48c9                	li	a7,18
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37a:	48a1                	li	a7,8
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <link>:
.global link
link:
 li a7, SYS_link
 382:	48cd                	li	a7,19
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38a:	48d1                	li	a7,20
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 392:	48a5                	li	a7,9
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <dup>:
.global dup
dup:
 li a7, SYS_dup
 39a:	48a9                	li	a7,10
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a2:	48ad                	li	a7,11
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3aa:	48b1                	li	a7,12
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b2:	48b5                	li	a7,13
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ba:	48b9                	li	a7,14
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c2:	1101                	addi	sp,sp,-32
 3c4:	ec06                	sd	ra,24(sp)
 3c6:	e822                	sd	s0,16(sp)
 3c8:	1000                	addi	s0,sp,32
 3ca:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ce:	4605                	li	a2,1
 3d0:	fef40593          	addi	a1,s0,-17
 3d4:	f6fff0ef          	jal	342 <write>
}
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	6105                	addi	sp,sp,32
 3de:	8082                	ret

00000000000003e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	7139                	addi	sp,sp,-64
 3e2:	fc06                	sd	ra,56(sp)
 3e4:	f822                	sd	s0,48(sp)
 3e6:	f426                	sd	s1,40(sp)
 3e8:	f04a                	sd	s2,32(sp)
 3ea:	ec4e                	sd	s3,24(sp)
 3ec:	0080                	addi	s0,sp,64
 3ee:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f0:	c299                	beqz	a3,3f6 <printint+0x16>
 3f2:	0605ce63          	bltz	a1,46e <printint+0x8e>
  neg = 0;
 3f6:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3f8:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3fc:	869a                	mv	a3,t1
  i = 0;
 3fe:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 400:	00000817          	auipc	a6,0x0
 404:	57080813          	addi	a6,a6,1392 # 970 <digits>
 408:	88be                	mv	a7,a5
 40a:	0017851b          	addiw	a0,a5,1
 40e:	87aa                	mv	a5,a0
 410:	02c5f73b          	remuw	a4,a1,a2
 414:	1702                	slli	a4,a4,0x20
 416:	9301                	srli	a4,a4,0x20
 418:	9742                	add	a4,a4,a6
 41a:	00074703          	lbu	a4,0(a4)
 41e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 422:	872e                	mv	a4,a1
 424:	02c5d5bb          	divuw	a1,a1,a2
 428:	0685                	addi	a3,a3,1
 42a:	fcc77fe3          	bgeu	a4,a2,408 <printint+0x28>
  if(neg)
 42e:	000e0c63          	beqz	t3,446 <printint+0x66>
    buf[i++] = '-';
 432:	fd050793          	addi	a5,a0,-48
 436:	00878533          	add	a0,a5,s0
 43a:	02d00793          	li	a5,45
 43e:	fef50823          	sb	a5,-16(a0)
 442:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 446:	fff7899b          	addiw	s3,a5,-1
 44a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 44e:	fff4c583          	lbu	a1,-1(s1)
 452:	854a                	mv	a0,s2
 454:	f6fff0ef          	jal	3c2 <putc>
  while(--i >= 0)
 458:	39fd                	addiw	s3,s3,-1
 45a:	14fd                	addi	s1,s1,-1
 45c:	fe09d9e3          	bgez	s3,44e <printint+0x6e>
}
 460:	70e2                	ld	ra,56(sp)
 462:	7442                	ld	s0,48(sp)
 464:	74a2                	ld	s1,40(sp)
 466:	7902                	ld	s2,32(sp)
 468:	69e2                	ld	s3,24(sp)
 46a:	6121                	addi	sp,sp,64
 46c:	8082                	ret
    x = -xx;
 46e:	40b005bb          	negw	a1,a1
    neg = 1;
 472:	4e05                	li	t3,1
    x = -xx;
 474:	b751                	j	3f8 <printint+0x18>

0000000000000476 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 476:	711d                	addi	sp,sp,-96
 478:	ec86                	sd	ra,88(sp)
 47a:	e8a2                	sd	s0,80(sp)
 47c:	e4a6                	sd	s1,72(sp)
 47e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 480:	0005c483          	lbu	s1,0(a1)
 484:	28048463          	beqz	s1,70c <vprintf+0x296>
 488:	e0ca                	sd	s2,64(sp)
 48a:	fc4e                	sd	s3,56(sp)
 48c:	f852                	sd	s4,48(sp)
 48e:	f456                	sd	s5,40(sp)
 490:	f05a                	sd	s6,32(sp)
 492:	ec5e                	sd	s7,24(sp)
 494:	e862                	sd	s8,16(sp)
 496:	e466                	sd	s9,8(sp)
 498:	8b2a                	mv	s6,a0
 49a:	8a2e                	mv	s4,a1
 49c:	8bb2                	mv	s7,a2
  state = 0;
 49e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4a0:	4901                	li	s2,0
 4a2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4a4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4a8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ac:	06c00c93          	li	s9,108
 4b0:	a00d                	j	4d2 <vprintf+0x5c>
        putc(fd, c0);
 4b2:	85a6                	mv	a1,s1
 4b4:	855a                	mv	a0,s6
 4b6:	f0dff0ef          	jal	3c2 <putc>
 4ba:	a019                	j	4c0 <vprintf+0x4a>
    } else if(state == '%'){
 4bc:	03598363          	beq	s3,s5,4e2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4c0:	0019079b          	addiw	a5,s2,1
 4c4:	893e                	mv	s2,a5
 4c6:	873e                	mv	a4,a5
 4c8:	97d2                	add	a5,a5,s4
 4ca:	0007c483          	lbu	s1,0(a5)
 4ce:	22048763          	beqz	s1,6fc <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 4d2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4d6:	fe0993e3          	bnez	s3,4bc <vprintf+0x46>
      if(c0 == '%'){
 4da:	fd579ce3          	bne	a5,s5,4b2 <vprintf+0x3c>
        state = '%';
 4de:	89be                	mv	s3,a5
 4e0:	b7c5                	j	4c0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4e2:	00ea06b3          	add	a3,s4,a4
 4e6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4ea:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ec:	c681                	beqz	a3,4f4 <vprintf+0x7e>
 4ee:	9752                	add	a4,a4,s4
 4f0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4f4:	05878263          	beq	a5,s8,538 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4f8:	05978c63          	beq	a5,s9,550 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4fc:	07500713          	li	a4,117
 500:	0ee78663          	beq	a5,a4,5ec <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 504:	07800713          	li	a4,120
 508:	12e78863          	beq	a5,a4,638 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 50c:	07000713          	li	a4,112
 510:	14e78d63          	beq	a5,a4,66a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 514:	07300713          	li	a4,115
 518:	18e78c63          	beq	a5,a4,6b0 <vprintf+0x23a>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == 'c'){
 51c:	06300713          	li	a4,99
 520:	1ce78163          	beq	a5,a4,6e2 <vprintf+0x26c>
        putc(fd, va_arg(ap, int));
      } else if(c0 == '%'){
 524:	02500713          	li	a4,37
 528:	04e79463          	bne	a5,a4,570 <vprintf+0xfa>
        putc(fd, '%');
 52c:	85ba                	mv	a1,a4
 52e:	855a                	mv	a0,s6
 530:	e93ff0ef          	jal	3c2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 534:	4981                	li	s3,0
 536:	b769                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 538:	008b8493          	addi	s1,s7,8
 53c:	4685                	li	a3,1
 53e:	4629                	li	a2,10
 540:	000ba583          	lw	a1,0(s7)
 544:	855a                	mv	a0,s6
 546:	e9bff0ef          	jal	3e0 <printint>
 54a:	8ba6                	mv	s7,s1
      state = 0;
 54c:	4981                	li	s3,0
 54e:	bf8d                	j	4c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 550:	06400793          	li	a5,100
 554:	02f68963          	beq	a3,a5,586 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 558:	06c00793          	li	a5,108
 55c:	04f68263          	beq	a3,a5,5a0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 560:	07500793          	li	a5,117
 564:	0af68063          	beq	a3,a5,604 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 568:	07800793          	li	a5,120
 56c:	0ef68263          	beq	a3,a5,650 <vprintf+0x1da>
        putc(fd, '%');
 570:	02500593          	li	a1,37
 574:	855a                	mv	a0,s6
 576:	e4dff0ef          	jal	3c2 <putc>
        putc(fd, c0);
 57a:	85a6                	mv	a1,s1
 57c:	855a                	mv	a0,s6
 57e:	e45ff0ef          	jal	3c2 <putc>
      state = 0;
 582:	4981                	li	s3,0
 584:	bf35                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 586:	008b8493          	addi	s1,s7,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e4dff0ef          	jal	3e0 <printint>
        i += 1;
 598:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59a:	8ba6                	mv	s7,s1
      state = 0;
 59c:	4981                	li	s3,0
        i += 1;
 59e:	b70d                	j	4c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a0:	06400793          	li	a5,100
 5a4:	02f60763          	beq	a2,a5,5d2 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5a8:	07500793          	li	a5,117
 5ac:	06f60963          	beq	a2,a5,61e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5b0:	07800793          	li	a5,120
 5b4:	faf61ee3          	bne	a2,a5,570 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b8:	008b8493          	addi	s1,s7,8
 5bc:	4681                	li	a3,0
 5be:	4641                	li	a2,16
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	e1bff0ef          	jal	3e0 <printint>
        i += 2;
 5ca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5cc:	8ba6                	mv	s7,s1
      state = 0;
 5ce:	4981                	li	s3,0
        i += 2;
 5d0:	bdc5                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d2:	008b8493          	addi	s1,s7,8
 5d6:	4685                	li	a3,1
 5d8:	4629                	li	a2,10
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	e01ff0ef          	jal	3e0 <printint>
        i += 2;
 5e4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e6:	8ba6                	mv	s7,s1
      state = 0;
 5e8:	4981                	li	s3,0
        i += 2;
 5ea:	bdd9                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5ec:	008b8493          	addi	s1,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4629                	li	a2,10
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	de7ff0ef          	jal	3e0 <printint>
 5fe:	8ba6                	mv	s7,s1
      state = 0;
 600:	4981                	li	s3,0
 602:	bd7d                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 604:	008b8493          	addi	s1,s7,8
 608:	4681                	li	a3,0
 60a:	4629                	li	a2,10
 60c:	000ba583          	lw	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	dcfff0ef          	jal	3e0 <printint>
        i += 1;
 616:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 618:	8ba6                	mv	s7,s1
      state = 0;
 61a:	4981                	li	s3,0
        i += 1;
 61c:	b555                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61e:	008b8493          	addi	s1,s7,8
 622:	4681                	li	a3,0
 624:	4629                	li	a2,10
 626:	000ba583          	lw	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	db5ff0ef          	jal	3e0 <printint>
        i += 2;
 630:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
        i += 2;
 636:	b569                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 638:	008b8493          	addi	s1,s7,8
 63c:	4681                	li	a3,0
 63e:	4641                	li	a2,16
 640:	000ba583          	lw	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	d9bff0ef          	jal	3e0 <printint>
 64a:	8ba6                	mv	s7,s1
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bd8d                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 650:	008b8493          	addi	s1,s7,8
 654:	4681                	li	a3,0
 656:	4641                	li	a2,16
 658:	000ba583          	lw	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	d83ff0ef          	jal	3e0 <printint>
        i += 1;
 662:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 664:	8ba6                	mv	s7,s1
      state = 0;
 666:	4981                	li	s3,0
        i += 1;
 668:	bda1                	j	4c0 <vprintf+0x4a>
 66a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 66c:	008b8d13          	addi	s10,s7,8
 670:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 674:	03000593          	li	a1,48
 678:	855a                	mv	a0,s6
 67a:	d49ff0ef          	jal	3c2 <putc>
  putc(fd, 'x');
 67e:	07800593          	li	a1,120
 682:	855a                	mv	a0,s6
 684:	d3fff0ef          	jal	3c2 <putc>
 688:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68a:	00000b97          	auipc	s7,0x0
 68e:	2e6b8b93          	addi	s7,s7,742 # 970 <digits>
 692:	03c9d793          	srli	a5,s3,0x3c
 696:	97de                	add	a5,a5,s7
 698:	0007c583          	lbu	a1,0(a5)
 69c:	855a                	mv	a0,s6
 69e:	d25ff0ef          	jal	3c2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a2:	0992                	slli	s3,s3,0x4
 6a4:	34fd                	addiw	s1,s1,-1
 6a6:	f4f5                	bnez	s1,692 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6a8:	8bea                	mv	s7,s10
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	6d02                	ld	s10,0(sp)
 6ae:	bd09                	j	4c0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6b0:	008b8993          	addi	s3,s7,8
 6b4:	000bb483          	ld	s1,0(s7)
 6b8:	cc91                	beqz	s1,6d4 <vprintf+0x25e>
        for(; *s; s++)
 6ba:	0004c583          	lbu	a1,0(s1)
 6be:	cd85                	beqz	a1,6f6 <vprintf+0x280>
          putc(fd, *s);
 6c0:	855a                	mv	a0,s6
 6c2:	d01ff0ef          	jal	3c2 <putc>
        for(; *s; s++)
 6c6:	0485                	addi	s1,s1,1
 6c8:	0004c583          	lbu	a1,0(s1)
 6cc:	f9f5                	bnez	a1,6c0 <vprintf+0x24a>
        if((s = va_arg(ap, char*)) == 0)
 6ce:	8bce                	mv	s7,s3
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b3fd                	j	4c0 <vprintf+0x4a>
          s = "(null)";
 6d4:	00000497          	auipc	s1,0x0
 6d8:	29448493          	addi	s1,s1,660 # 968 <malloc+0x170>
        for(; *s; s++)
 6dc:	02800593          	li	a1,40
 6e0:	b7c5                	j	6c0 <vprintf+0x24a>
        putc(fd, va_arg(ap, int));
 6e2:	008b8493          	addi	s1,s7,8
 6e6:	000bc583          	lbu	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	cd7ff0ef          	jal	3c2 <putc>
 6f0:	8ba6                	mv	s7,s1
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b3f1                	j	4c0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6f6:	8bce                	mv	s7,s3
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b3d9                	j	4c0 <vprintf+0x4a>
 6fc:	6906                	ld	s2,64(sp)
 6fe:	79e2                	ld	s3,56(sp)
 700:	7a42                	ld	s4,48(sp)
 702:	7aa2                	ld	s5,40(sp)
 704:	7b02                	ld	s6,32(sp)
 706:	6be2                	ld	s7,24(sp)
 708:	6c42                	ld	s8,16(sp)
 70a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 70c:	60e6                	ld	ra,88(sp)
 70e:	6446                	ld	s0,80(sp)
 710:	64a6                	ld	s1,72(sp)
 712:	6125                	addi	sp,sp,96
 714:	8082                	ret

0000000000000716 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 716:	715d                	addi	sp,sp,-80
 718:	ec06                	sd	ra,24(sp)
 71a:	e822                	sd	s0,16(sp)
 71c:	1000                	addi	s0,sp,32
 71e:	e010                	sd	a2,0(s0)
 720:	e414                	sd	a3,8(s0)
 722:	e818                	sd	a4,16(s0)
 724:	ec1c                	sd	a5,24(s0)
 726:	03043023          	sd	a6,32(s0)
 72a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 72e:	8622                	mv	a2,s0
 730:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 734:	d43ff0ef          	jal	476 <vprintf>
  va_end(ap);
}
 738:	60e2                	ld	ra,24(sp)
 73a:	6442                	ld	s0,16(sp)
 73c:	6161                	addi	sp,sp,80
 73e:	8082                	ret

0000000000000740 <printf>:

void
printf(const char *fmt, ...)
{
 740:	711d                	addi	sp,sp,-96
 742:	ec06                	sd	ra,24(sp)
 744:	e822                	sd	s0,16(sp)
 746:	1000                	addi	s0,sp,32
 748:	e40c                	sd	a1,8(s0)
 74a:	e810                	sd	a2,16(s0)
 74c:	ec14                	sd	a3,24(s0)
 74e:	f018                	sd	a4,32(s0)
 750:	f41c                	sd	a5,40(s0)
 752:	03043823          	sd	a6,48(s0)
 756:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 75a:	00840613          	addi	a2,s0,8
 75e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 762:	85aa                	mv	a1,a0
 764:	4505                	li	a0,1
 766:	d11ff0ef          	jal	476 <vprintf>
  va_end(ap);
}
 76a:	60e2                	ld	ra,24(sp)
 76c:	6442                	ld	s0,16(sp)
 76e:	6125                	addi	sp,sp,96
 770:	8082                	ret

0000000000000772 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 772:	1141                	addi	sp,sp,-16
 774:	e406                	sd	ra,8(sp)
 776:	e022                	sd	s0,0(sp)
 778:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77e:	00001797          	auipc	a5,0x1
 782:	8827b783          	ld	a5,-1918(a5) # 1000 <freep>
 786:	a02d                	j	7b0 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 788:	4618                	lw	a4,8(a2)
 78a:	9f2d                	addw	a4,a4,a1
 78c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 790:	6398                	ld	a4,0(a5)
 792:	6310                	ld	a2,0(a4)
 794:	a83d                	j	7d2 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 796:	ff852703          	lw	a4,-8(a0)
 79a:	9f31                	addw	a4,a4,a2
 79c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 79e:	ff053683          	ld	a3,-16(a0)
 7a2:	a091                	j	7e6 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a4:	6398                	ld	a4,0(a5)
 7a6:	00e7e463          	bltu	a5,a4,7ae <free+0x3c>
 7aa:	00e6ea63          	bltu	a3,a4,7be <free+0x4c>
{
 7ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b0:	fed7fae3          	bgeu	a5,a3,7a4 <free+0x32>
 7b4:	6398                	ld	a4,0(a5)
 7b6:	00e6e463          	bltu	a3,a4,7be <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	fee7eae3          	bltu	a5,a4,7ae <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7be:	ff852583          	lw	a1,-8(a0)
 7c2:	6390                	ld	a2,0(a5)
 7c4:	02059813          	slli	a6,a1,0x20
 7c8:	01c85713          	srli	a4,a6,0x1c
 7cc:	9736                	add	a4,a4,a3
 7ce:	fae60de3          	beq	a2,a4,788 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7d2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d6:	4790                	lw	a2,8(a5)
 7d8:	02061593          	slli	a1,a2,0x20
 7dc:	01c5d713          	srli	a4,a1,0x1c
 7e0:	973e                	add	a4,a4,a5
 7e2:	fae68ae3          	beq	a3,a4,796 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7e6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e8:	00001717          	auipc	a4,0x1
 7ec:	80f73c23          	sd	a5,-2024(a4) # 1000 <freep>
}
 7f0:	60a2                	ld	ra,8(sp)
 7f2:	6402                	ld	s0,0(sp)
 7f4:	0141                	addi	sp,sp,16
 7f6:	8082                	ret

00000000000007f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f8:	7139                	addi	sp,sp,-64
 7fa:	fc06                	sd	ra,56(sp)
 7fc:	f822                	sd	s0,48(sp)
 7fe:	f04a                	sd	s2,32(sp)
 800:	ec4e                	sd	s3,24(sp)
 802:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 804:	02051993          	slli	s3,a0,0x20
 808:	0209d993          	srli	s3,s3,0x20
 80c:	09bd                	addi	s3,s3,15
 80e:	0049d993          	srli	s3,s3,0x4
 812:	2985                	addiw	s3,s3,1
 814:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 816:	00000517          	auipc	a0,0x0
 81a:	7ea53503          	ld	a0,2026(a0) # 1000 <freep>
 81e:	c905                	beqz	a0,84e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 820:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 822:	4798                	lw	a4,8(a5)
 824:	09377663          	bgeu	a4,s3,8b0 <malloc+0xb8>
 828:	f426                	sd	s1,40(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 830:	8a4e                	mv	s4,s3
 832:	6705                	lui	a4,0x1
 834:	00e9f363          	bgeu	s3,a4,83a <malloc+0x42>
 838:	6a05                	lui	s4,0x1
 83a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 83e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 842:	00000497          	auipc	s1,0x0
 846:	7be48493          	addi	s1,s1,1982 # 1000 <freep>
  if(p == (char*)-1)
 84a:	5afd                	li	s5,-1
 84c:	a83d                	j	88a <malloc+0x92>
 84e:	f426                	sd	s1,40(sp)
 850:	e852                	sd	s4,16(sp)
 852:	e456                	sd	s5,8(sp)
 854:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 856:	00000797          	auipc	a5,0x0
 85a:	7ba78793          	addi	a5,a5,1978 # 1010 <base>
 85e:	00000717          	auipc	a4,0x0
 862:	7af73123          	sd	a5,1954(a4) # 1000 <freep>
 866:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 868:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 86c:	b7d1                	j	830 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 86e:	6398                	ld	a4,0(a5)
 870:	e118                	sd	a4,0(a0)
 872:	a899                	j	8c8 <malloc+0xd0>
  hp->s.size = nu;
 874:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 878:	0541                	addi	a0,a0,16
 87a:	ef9ff0ef          	jal	772 <free>
  return freep;
 87e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 880:	c125                	beqz	a0,8e0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 882:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 884:	4798                	lw	a4,8(a5)
 886:	03277163          	bgeu	a4,s2,8a8 <malloc+0xb0>
    if(p == freep)
 88a:	6098                	ld	a4,0(s1)
 88c:	853e                	mv	a0,a5
 88e:	fef71ae3          	bne	a4,a5,882 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 892:	8552                	mv	a0,s4
 894:	b17ff0ef          	jal	3aa <sbrk>
  if(p == (char*)-1)
 898:	fd551ee3          	bne	a0,s5,874 <malloc+0x7c>
        return 0;
 89c:	4501                	li	a0,0
 89e:	74a2                	ld	s1,40(sp)
 8a0:	6a42                	ld	s4,16(sp)
 8a2:	6aa2                	ld	s5,8(sp)
 8a4:	6b02                	ld	s6,0(sp)
 8a6:	a03d                	j	8d4 <malloc+0xdc>
 8a8:	74a2                	ld	s1,40(sp)
 8aa:	6a42                	ld	s4,16(sp)
 8ac:	6aa2                	ld	s5,8(sp)
 8ae:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8b0:	fae90fe3          	beq	s2,a4,86e <malloc+0x76>
        p->s.size -= nunits;
 8b4:	4137073b          	subw	a4,a4,s3
 8b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ba:	02071693          	slli	a3,a4,0x20
 8be:	01c6d713          	srli	a4,a3,0x1c
 8c2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c8:	00000717          	auipc	a4,0x0
 8cc:	72a73c23          	sd	a0,1848(a4) # 1000 <freep>
      return (void*)(p + 1);
 8d0:	01078513          	addi	a0,a5,16
  }
}
 8d4:	70e2                	ld	ra,56(sp)
 8d6:	7442                	ld	s0,48(sp)
 8d8:	7902                	ld	s2,32(sp)
 8da:	69e2                	ld	s3,24(sp)
 8dc:	6121                	addi	sp,sp,64
 8de:	8082                	ret
 8e0:	74a2                	ld	s1,40(sp)
 8e2:	6a42                	ld	s4,16(sp)
 8e4:	6aa2                	ld	s5,8(sp)
 8e6:	6b02                	ld	s6,0(sp)
 8e8:	b7f5                	j	8d4 <malloc+0xdc>
