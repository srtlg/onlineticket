import sys
import onlineticket

if __name__ == '__main__':
    onlineticket.DEBUG = 1
    if len(sys.argv) != 2:
        print('Usage: %s ticket_file' % sys.argv[0])
    path = sys.argv[1]
    with open(path, 'rb') as fin:
        ticket_bin = fin.read()
    ot = onlineticket.OT(onlineticket.fix_zxing(ticket_bin))
    print(onlineticket.dict_str({path: ot}))

