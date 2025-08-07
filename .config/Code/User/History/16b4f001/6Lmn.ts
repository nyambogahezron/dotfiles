import multer from 'multer';
import path from 'path';

const storage = multer.diskStorage({
	destination: function (
		req: Express.Request,
		file: Express.Multer.File,
		cb: (error: Error | null, destination: string) => void
	) {
		cb(null, 'uploads/');
	},
	filename: function (
		req: Express.Request,
		file: Express.Multer.File,
		cb: (error: Error | null, filename: string) => void
	) {
		cb(null, Date.now() + path.extname(file.originalname));
	},
});

function checkFileType(
	file: Express.Multer.File,
	cb: multer.FileFilterCallback
): void {
	const filetypes = /jpeg|jpg|png|gif/;
	const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
	const mimetype = filetypes.test(file.mimetype);

	if (mimetype && extname) {
		return cb(null, true);
	} else {
		cb(new Error('Error: Images Only!'));
	}
}

const upload = multer({
	storage: storage,
	limits: { fileSize: 1000000 },
	fileFilter: function (
		req: Express.Request,
		file: Express.Multer.File,
		cb: multer.FileFilterCallback
	) {
		checkFileType(file, cb);
	},
}).single('file');

export default upload;
